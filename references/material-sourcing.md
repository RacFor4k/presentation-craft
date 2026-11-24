# Material sourcing

Цель — не «подобрать красивую картинку», а собрать **реальный материал**, из которого
вырастает колода. Ошибка №1 в сгенерированных презентациях: абстрактный плакат из
крупного шрифта, потому что материал не искали вообще.

## Что считается материалом

- фотографии и кадры миссий (NASA, ESA, JAXA, Роскосмос);
- сканы книг, гравюр, карт, патентов, рукописей;
- реальные диаграммы, графики, таблицы, чертежи;
- продуктовые кадры и скриншоты реального продукта;
- портреты, архивные фото, обложки изданий;
- цитаты и документы, если тема гуманитарная.

Не считается: стоковые «улыбающиеся люди», AI-рендеры под фотографию, светящиеся
сферы, декоративные орбиты, изображения с водяными знаками, обои из поиска картинок
без источника.

## Ворота

`notes/material-audit.md` должен существовать **до** выбора палитры, шрифтов и пробников.
В нём 5–10 строк:

```
актив | источник | лицензия | разрешение | кроп/роль | кредит
```

Пример:

```
earthrise_169 | NASA / Orion, 2022, images-assets.nasa.gov | public domain | 5568×3712 | full-bleed cover, Earth right | NASA / Orion
principia_page | Christie's 1998, first edition 1687 | public domain work, photo credit | 1000×1400 | artifact plate, right | Christie's
earth_disk | NASA / Apollo 17 Blue Marble | public domain | 2048² | cutout, law slide | NASA / Apollo 17
```

Если в таблице меньше 5 реальных активов, колода будет плакатом. Ищи ещё или меняй язык.

## NASA Images API

```bash
# 1. Search
https://images-api.nasa.gov/search?q=earthrise%20apollo%208&media_type=image

# 2. Asset list by NASA ID
https://images-api.nasa.gov/asset/art002e021278

# 3. Download the largest useful JPEG
https://images-assets.nasa.gov/image/art002e021278/art002e021278~orig.jpg
```

- В ответе `collection.items[].data[0]` — `nasa_id`, `title`, `description`;
  `links[0].href` — превью.
- В `asset/<id>` бери `~orig.jpg`, иначе `~large.jpg`, иначе `~medium.jpg`.
- NASA-контент обычно public domain; кредит обязателен: `NASA / <mission>`.
- Не бери первое попадание: проверь, что это фотография, а не artist concept,
  и что кадр читается в 16:9.
- Для полного диска планеты ищи `Full disk`, `globe`, `Blue Marble`, `Cassini`,
  `Hubble`, `LRO`, `SDO`, `DSCOVR EPIC`.

## Internet Archive

Хорош для книг, гравюр, титульных листов, исторических изданий.

```bash
# Search
https://archive.org/advancedsearch.php?q=title:(principia)+AND+creator:(newton)&fl[]=identifier&fl[]=title&fl[]=year&rows=12&output=json

# Metadata: server + dir
https://archive.org/metadata/<identifier>

# Page image (n = leaf index)
https://archive.org/download/<identifier>/page/n0_w900.jpg
```

- Скан может начинаться с аукционного каталога, обложки или пустых листов.
  Сделай контакт-лист первых 15 страниц и выбери реальный титул/разворот.
- Перспективу страницы исправляй `cv2.getPerspectiveTransform`; не оставляй
  синие поля каталога вокруг кремовой страницы.
- Кредит: издание, год, источник фотографии (например, Christie's).

## Wikimedia

С этой машины Wikimedia часто отдаёт HTTP 429 (`upload.wikimedia.org`,
`Special:FilePath`). Не трать время на обход: ищи тот же public-domain материал
в Internet Archive, Library of Congress, музее или на сайте миссии.

## Library of Congress / музеи

- LoC: `https://www.loc.gov/search/?q=...&fo=json` — много public-domain.
- Музеи и архивы: ищи страницу объекта и кнопку download/open access; API может
  быть закрыт (Met API, например, отдавал 410 — тогда только сайт).
- Всегда фиксируй точный URL и лицензию в audit.

## Разрешение и кроп

- Full-bleed 16:9: исходник ≥ 2000 px по ширине, лучше 2500–3500.
- Вставка/портрет: ≥ 1000 px.
- Круглый вырез планеты: ≥ 1200×1200.
- Не растягивай: только пропорциональный кроп.
- Для full-bleed ищи **спокойную зону** под текст: чёрное небо, тёмный космос,
  однотонная стена. Если её нет, перекрои кадр, а не заливай всё скримом.
- Для коллажа планет делай круги с альфой и проверяй, что чёрный фон совпадает
  с фоном слайда; иначе вокруг диска появится квадрат.

## Подготовка изображений

`scripts/prepare_image.py`:

```bash
# 16:9 crop, focus 0.5 = center vertically
python scripts/prepare_image.py crop --src earth.jpg --dst earth_169.jpg --ratio 16:9 --width 2560

# square, for a planet plate
python scripts/prepare_image.py square --src earth.jpg --dst earth_square.jpg --size 1600

# circular cutout with alpha, pad 1.01 keeps a thin rim
python scripts/prepare_image.py disk --src earth.jpg --dst earth_disk.png --size 1200 --pad 1.01
```

Проверяй результат глазами: PIL может идеально обрезать, но Земля окажется
в правом нижнем углу, а Солнце — обрезанным.

## Если материала нет

Честные варианты:

- данные и таблицы как главный объект;
- реальная схема/чертёж, которую можно построить из содержания;
- типографика без фотографий, но с сильной мыслью и строгой сеткой;
- скриншоты реального продукта.

Нечестный вариант: имитировать «кинодокумент» декоративными орбитами, золотом на
чёрном и гигантскими словами. Это и есть нейрослоп.

## Кредиты

- На слайде: мелкая строка `NASA / Orion, 2022` или `NASA / JPL / Cassini`.
- В `README.md`: полный список источников и лицензий.
- Если лицензия не public domain (ESA/Hubble, музей), проверь условия и не обещай
  коммерческое использование.
