# PPTX toolcraft

Практика генерации `.pptx` кодом, проверенная на pptxgenjs 4.0.1 + PowerPoint 2021 COM
(Windows) и на PowerPoint 2019/365. LibreOffice — только fallback для Linux/macOS,
он хуже воспроизводит шрифты и не показывает Morph.

## Пайплайн

```
материал -> генератор (js/py) -> .pptx -> PowerPoint PNG -> просмотр всех слайдов
         -> правки -> видео переходов -> validate.py -> PDF/превью/контакт-лист
```

Без рендера не считать слайд готовым: код не показывает наложений, обрезки и того,
что фото закрыло шапку.

## pptxgenjs: что ломается

- `pres.layout` ставить **до** добавления слайдов. По умолчанию 10×5,625, а не 13,3.
- Цвета — строка без `#`, ровно 6 знаков. `#FF0000` или альфа в hex портят файл.
- `transparency: 0-100` — для заливок и картинок; `opacity` — только для теней.
- Опции объектов мутируются: нельзя переиспользовать один `shadow`/`options`.
- `margin: 0` на каждом текстовом блоке, иначе текст съезжает относительно линий.
- `valign` по умолчанию центрирует: если нужен верх — `valign: "top"` явно.
- `isTextBox: true` на каждом `addText` без placeholder.
- Списки: `bullet: true` на каждом пункте и `breakLine: true`, не символ «•».
- `rectRadius` работает только у `ROUNDED_RECTANGLE`.
- Тени: `offset` не бывает отрицательным.
- Один `new pptxgen()` на файл.
- Гигантский кегль: блок выше глифа на 10–15 %, иначе буква обрезается.
- Поворот: размеры блока задаются **до** поворота; узкий блок сложит текст по буквам.
- **Отрицательные `w`/`h` у линии портят файл.** Для стрелки влево задай
  `x` левого конца, положительный `w` и `beginArrow: "triangle"`.
- `objectName: "!!earth"` — имя для Morph; одинаково на соседних слайдах.
- Таблицы: `addTable` рисует полную сетку. Для «научной» таблицы собрать вручную —
  текстовые блоки + горизонтальные линии.
- `s.background = { color: "000000" }` пишет заливку слайда. Полноэкранный
  прямоугольник её **не заменяет**: при Morph может проступить белый мастер.
- Полноэкранное фото добавлять **до** шапки/индекса/кредита. Иначе фото их закрывает.
- PNG с альфой: PowerPoint обычно чтит альфу, но чёрный фон внутри круга может
  остаться квадратом. Проверяй рендер; для планет лучше чистый круг с прозрачностью
  и фон слайда того же цвета, что и фон картинки.

## Шрифты

- Проверять кириллицу через `fontTools`/cmap и обязательно рендером в PowerPoint.
- Рабочая пара для документального стиля: **Bahnschrift + Segoe UI + Cambria + Consolas**.
- Bahnschrift — Windows 10+; на чужой машине может отсутствовать.
  Резерв: Segoe UI Semibold.
- Не делать Arial Black + Georgia дефолтом: это самый узнаваемый шаблон генератора.
- Экзотические шрифты — только если пользователь их пришлёт и они стоят на машине показа.

## Рендер на Windows

```powershell
powershell -ExecutionPolicy Bypass -File scripts/render_windows.ps1 `
  -Pptx deck.pptx -OutDir slides -Width 1600 -Height 900
```

- Скрипт поднимает PowerPoint COM, экспортирует PNG, закрывает файл.
- PowerPoint на русской локали называет файлы `Слайд1.PNG`, на английской `Slide1.PNG`.
  Скрипт сортирует по числу, а не по имени.
- Если файл открыт у пользователя — закрыть, иначе экспорт упадёт.
- Проверяй каждый PNG глазами. Это единственная надёжная проверка текста на фото.

## Видео переходов

```powershell
powershell -ExecutionPolicy Bypass -File scripts/render_video.ps1 `
  -Pptx deck.pptx -Out preview.mp4 -SlideSeconds 3 -Fps 30
```

- PowerPoint `CreateVideo` рендерит переходы; ждать `CreateVideoStatus == 3`.
- 11 слайдов по 3 с + переходы ≈ 40–45 с.
- Вытащи кадры `ffmpeg -ss 2.4 -i preview.mp4 -frames:v 1 frame.png` и проверь
  чёрные провалы, белые вспышки, двойные заголовки.
- Статический рендер не доказывает, что Morph работает.

## PDF

```powershell
powershell -ExecutionPolicy Bypass -File scripts/export_pdf.ps1 `
  -Pptx deck.pptx -Pdf deck.pdf
```

PDF — резервная копия для печати/просмотра. Переходы в нём не сохраняются; не обещай
«PDF с анимацией».

## Morph и fade

`scripts/add_morph.py` добавляет переходы в slide XML:

```bash
python scripts/add_morph.py deck.pptx --dur 500 --fade-dur 100 \
  --fade 2,3,6,7,8,9,10,11
```

- Transition живёт на входящем слайде, после `</p:clrMapOvr>`.
- Morph — `p159` + `mc:AlternateContent` с fade fallback.
- Fade — обычный `<p:transition><p:fade/></p:transition>`.
- Morph только для объектов с одинаковым `!!` именем; иначе чёрный провал.
- Подробности — `morph-choreography.md`.

## Валидация

```bash
python <pptx-skill>/scripts/office/validate.py deck.pptx
```

- Схема, связи, чарты; для шаблонов — `--original template.pptx`.
- `validate.py` не ловит всё, что PowerPoint «чинит»; видео и открытие файла важнее.
- Проверить, что в ZIP нет папок:

```python
import zipfile
z = zipfile.ZipFile("deck.pptx")
print([n for n in z.namelist() if n.endswith("/")])
```

Служебные папки (`ppt/`, `ppt/media/`) не мешают PowerPoint, но могут ломать
облачное соавторство. Удалять при сборке.

## Текст и заметки

```bash
python <pptx-skill>/scripts/slide_text.py deck.pptx
```

Или python-pptx:

```python
from pptx import Presentation
p = Presentation("deck.pptx")
for i, slide in enumerate(p.slides, 1):
    print(i, [s.text for s in slide.shapes if s.has_text_frame])
    print(slide.notes_slide.notes_text_frame.text)
```

Проверить: нет placeholder-текста, дублей, пустых заметок.

## Изображения

- `scripts/prepare_image.py` — 16:9 crop, square, круглый вырез с альфой.
- Full-bleed ≥ 2000 px по ширине; вставка ≥ 1000 px.
- Не растягивать; кроп по фокусу.
- Проверять, что главный объект не отрезан (Земля, Земля+Луна, Сатурн).
- Кредит — на слайде мелким Consolas и в README.

## Linux/macOS

```bash
bash scripts/render_linux.sh deck.pptx slides
```

LibreOffice + Poppler. Шрифты и отступы могут отличаться от PowerPoint; не судить
по этому рендеру финальную типографику. Morph не проверить — нужен PowerPoint.
