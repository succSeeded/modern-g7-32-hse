#import "headings.typ": structural-heading-titles, structure-heading-style

#let get-count(kind) = {
  assert(
    kind in (page, image, table, ref, "appendix"),
    message: "Невозможно определить количество этих элементов",
  )
  let target-counter = none
  let caption = none
  if kind == page {
    target-counter = counter(page)
    caption = "с."
  } else if kind == "appendix" {
    target-counter = counter("appendix")
    caption = "прил."
  } else if kind == ref {
    caption = "ист."
  } else if kind == image {
    target-counter = counter("image")
    caption = "рис."
  } else if kind == table {
    target-counter = counter("table")
    caption = "табл."
  }

  let count = 0
  if kind == cite {
    count = target-counter.final().dedup().len()
  } else if kind == ref {
    count = query(selector(ref))
      .filter(it => it.element == none)
      .map(it => it.target)
      .dedup()
      .len()
  } else {
    count = target-counter.final().first()
  }

  if count != 0 {
    repr(count) + " " + caption
  }
}

#let abstract(count: true, 
  body,
  body-ru,
  keywords,
  keywords-ru,
) = {
  [
    #heading(structural-heading-titles.abstract, outlined: false) <abstract>
    #context if count {
      let counts = (
        get-count(page),
        get-count(image),
        get-count(table),
        get-count(ref),
        get-count("appendix"),
      )
      counts = counts.filter(it => it != none)
      [Отчет #counts.join(", ")]
    }

    #text(body-ru)

    #{
      set par(first-line-indent: 0pt)
      strong([Ключевые слова: ])
      upper(keywords-ru.join(", "))
    }

    #strong(structure-heading-style([Abstract]))
    #text(body)

    #{
      set par(first-line-indent: 0pt)
      strong([Keywords: ])  
      upper(keywords.join(", "))
    }
  ]
}
