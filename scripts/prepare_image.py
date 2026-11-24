#!/usr/bin/env python3
"""Prepare real images for a deck: crop, square, circular cutout.

Examples:
  python prepare_image.py crop --src earth.jpg --dst earth_169.jpg --ratio 16:9 --width 2560
  python prepare_image.py crop --src earth.jpg --dst earth_169.jpg --ratio 16:9 --focus 0.35
  python prepare_image.py square --src earth.jpg --dst earth_square.jpg --size 1600
  python prepare_image.py disk --src earth.jpg --dst earth_disk.png --size 1200 --pad 1.01
"""
import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


def _ratio(value: str) -> float:
    if ":" in value:
        a, b = value.split(":", 1)
        return float(a) / float(b)
    return float(value)


def crop_ratio(im: Image.Image, ratio: float, focus: float) -> Image.Image:
    w, h = im.size
    target_h = int(w / ratio)
    if target_h <= h:
        top = int((h - target_h) * focus)
        top = max(0, min(h - target_h, top))
        return im.crop((0, top, w, top + target_h))
    target_w = int(h * ratio)
    left = max(0, min(w - target_w, (w - target_w) // 2))
    return im.crop((left, 0, left + target_w, h))


def resize_max(im: Image.Image, max_w: int) -> Image.Image:
    if im.width <= max_w:
        return im
    h = int(im.height * max_w / im.width)
    return im.resize((max_w, h), Image.LANCZOS)


def cmd_crop(args):
    im = Image.open(args.src).convert("RGB")
    im = crop_ratio(im, _ratio(args.ratio), args.focus)
    im = resize_max(im, args.width)
    im.save(args.dst, quality=args.quality, subsampling=1)
    print(f"{args.dst} {im.size[0]}x{im.size[1]}")


def cmd_square(args):
    im = Image.open(args.src).convert("RGB")
    w, h = im.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    im = im.crop((left, top, left + side, top + side)).resize((args.size, args.size), Image.LANCZOS)
    im.save(args.dst, quality=args.quality, subsampling=1)
    print(f"{args.dst} {args.size}x{args.size}")


def cmd_disk(args):
    im = Image.open(args.src).convert("RGBA")
    w, h = im.size
    side = min(w, h)
    im = im.crop(((w - side) // 2, (h - side) // 2, (w + side) // 2, (h + side) // 2))
    im = im.resize((args.size, args.size), Image.LANCZOS)

    # A soft alpha edge; pad > 1 leaves a thin rim of the original background.
    mask = Image.new("L", (args.size * 4, args.size * 4), 0)
    d = ImageDraw.Draw(mask)
    margin = int(args.size * 4 * (1 - 1 / args.pad) / 2)
    d.ellipse((margin, margin, args.size * 4 - margin, args.size * 4 - margin), fill=255)
    mask = mask.resize((args.size, args.size), Image.LANCZOS).filter(ImageFilter.GaussianBlur(1.2))
    im.putalpha(mask)
    im.save(args.dst)
    print(f"{args.dst} {args.size}x{args.size} RGBA")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    c = sub.add_parser("crop", help="crop to a ratio")
    c.add_argument("--src", required=True)
    c.add_argument("--dst", required=True)
    c.add_argument("--ratio", default="16:9")
    c.add_argument("--focus", type=float, default=0.5, help="0 top, 0.5 center, 1 bottom")
    c.add_argument("--width", type=int, default=2560)
    c.add_argument("--quality", type=int, default=92)
    c.set_defaults(func=cmd_crop)

    s = sub.add_parser("square", help="center square")
    s.add_argument("--src", required=True)
    s.add_argument("--dst", required=True)
    s.add_argument("--size", type=int, default=1600)
    s.add_argument("--quality", type=int, default=92)
    s.set_defaults(func=cmd_square)

    d = sub.add_parser("disk", help="circular cutout with alpha")
    d.add_argument("--src", required=True)
    d.add_argument("--dst", required=True)
    d.add_argument("--size", type=int, default=1200)
    d.add_argument("--pad", type=float, default=1.01, help="1.0 = tight; 1.02 keeps a rim")
    d.set_defaults(func=cmd_disk)

    args = ap.parse_args()
    Path(args.dst).parent.mkdir(parents=True, exist_ok=True)
    args.func(args)


if __name__ == "__main__":
    main()
