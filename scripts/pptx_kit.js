// Generic pptxgenjs helpers. No palette, no layout system: pass your own values.
// Copy next to your generator and require it.
//
//   const { deck, bg, text, line, circle, image } = require("./pptx_kit");
//   const pres = deck({ title: "Deck" });
//   const s = pres.addSlide();
//   bg(pres, s, "000000");
//   text(pres, s, "Title", { x: 0.6, y: 0.6, w: 8, h: 1, size: 44, font: "Bahnschrift" });

const pptxgen = require("pptxgenjs");

const W = 13.333;
const H = 7.5;

function deck(meta = {}) {
  const pres = new pptxgen();
  pres.layout = "LAYOUT_WIDE";
  if (meta.title) pres.title = meta.title;
  if (meta.subject) pres.subject = meta.subject;
  if (meta.author) pres.author = meta.author;
  if (meta.company) pres.company = meta.company;
  return pres;
}

function bg(pres, slide, color) {
  slide.background = { color };
  slide.addShape(pres.ShapeType.rect, {
    x: 0, y: 0, w: W, h: H,
    fill: { color },
    line: { color, width: 0 },
    objectName: "!!bg",
  });
}

function text(pres, slide, str, o = {}) {
  slide.addText(str, {
    x: o.x ?? 0.6,
    y: o.y ?? 0.6,
    w: o.w ?? 6,
    h: o.h ?? 0.5,
    fontFace: o.font ?? "Segoe UI",
    fontSize: o.size ?? 16,
    color: o.color ?? "FFFFFF",
    bold: !!o.bold,
    italic: !!o.italic,
    charSpacing: o.tracking ?? 0,
    align: o.align ?? "left",
    valign: o.valign ?? "top",
    lineSpacing: o.leading,
    margin: o.margin ?? 0,
    isTextBox: true,
    objectName: o.name,
    rotate: o.rotate,
  });
}

function line(pres, slide, o) {
  if (o.w < 0 || o.h < 0) {
    throw new Error("line(): w/h must be >= 0; use beginArrow for a left-pointing arrow");
  }
  slide.addShape(pres.ShapeType.line, {
    x: o.x, y: o.y, w: o.w, h: o.h,
    line: {
      color: o.color ?? "FFFFFF",
      width: o.width ?? 0.75,
      dash: o.dash,
      beginArrowType: o.beginArrow,
      endArrowType: o.endArrow,
    },
    objectName: o.name,
  });
}

function rect(pres, slide, o) {
  slide.addShape(pres.ShapeType.rect, {
    x: o.x, y: o.y, w: o.w, h: o.h,
    fill: { color: o.fill ?? "FFFFFF", transparency: o.transparency ?? 0 },
    line: o.line ? { color: o.line, width: o.lineWidth ?? 0.75 } : { color: o.fill ?? "FFFFFF", width: 0 },
    objectName: o.name,
  });
}

function circle(pres, slide, o) {
  const d = o.d ?? Math.min(o.w ?? 1, o.h ?? 1);
  slide.addShape(pres.ShapeType.ellipse, {
    x: o.x, y: o.y, w: o.w ?? d, h: o.h ?? d,
    fill: o.fill ? { color: o.fill, transparency: o.transparency ?? 0 } : { color: "FFFFFF", transparency: 100 },
    line: o.line ? { color: o.line, width: o.lineWidth ?? 0.75 } : { color: o.fill ?? "FFFFFF", width: 0 },
    objectName: o.name,
  });
}

function ellipse(pres, slide, o) {
  circle(pres, slide, { ...o, w: o.w, h: o.h });
}

function image(slide, o) {
  slide.addImage({
    path: o.path,
    x: o.x, y: o.y, w: o.w, h: o.h,
    transparency: o.transparency,
    objectName: o.name,
  });
}

function notes(slide, str) {
  slide.addNotes(str);
}

module.exports = { pptxgen, W, H, deck, bg, text, line, rect, circle, ellipse, image, notes };
