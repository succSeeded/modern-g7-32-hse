#import "../component/title.typ": (
  approved-and-agreed-fields, detailed-sign-field, per-line,
)
#import "../utils.typ": fetch-field, sign-field

#let arguments(..args, year: auto) = {
  let args = args.named()
  args.organization = fetch-field(
    args.at("organization", default: none),
    ("*full", "short"),
    hint: "организации",
  )
  args.approved-by = fetch-field(
    args.at("approved-by", default: none),
    ("name*", "position*", "year"),
    default: (year: auto),
    hint: "согласования",
  )
  args.agreed-by = fetch-field(
    args.at("agreed-by", default: none),
    ("name*", "position*", "year"),
    default: (year: auto),
    hint: "утверждения",
  )
  args.stage = fetch-field(
    args.at("stage", default: none),
    ("type*", "num"),
    hint: "этапа",
  )
  args.manager = fetch-field(
    args.at("manager", default: none),
    ("position*", "name*", "title"),
    default: (title: "Руководитель НИР,"),
    hint: "руководителя",
  )

  if args.approved-by.year == auto {
    args.approved-by.year = year
  }
  if args.agreed-by.year == auto {
    args.agreed-by.year = year
  }
  return args
}

#let template(
  ministry: none,
  organization: (full: none, short: none),
  faculty: none,
  udk: none,
  research-number: none,
  report-number: none,
  approved-by: (name: none, position: none, year: auto),
  agreed-by: (name: none, position: none, year: none),
  report-type: "Отчёт",
  about: none,
  bare-subject: false,
  research: none,
  subject: none,
  subject-ru: none,
  field-of-study: none,
  study-level: none,
  study-programme: none,
  part: none,
  stage: none,
  manager: (position: none, name: none, title: none),
  performer: none,
) = {
  per-line(
    force-indent: true,
    ministry,
    (value: upper(organization.full), when-present: organization.full),
    (value: upper[(#organization.short)], when-present: organization.short),
    (value: upper(faculty), when-present: faculty),
  )

  per-line(
    force-indent: true,
    align: left,
    (value: [УДК: #udk], when-present: udk),
    (value: [Рег. №: #research-number], when-present: research-number),
    (value: [Рег. № ИКРБС: #report-number], when-present: report-number),
  )

  per-line(
    force-indent: true,
    (value: performer.at("fullname", default: performer.at("name")), when-present: performer)
  )

  approved-and-agreed-fields(approved-by, agreed-by)

  per-line(
    align: center,
    indent: 2fr,
    (value: upper(about), when-present: about),
    (value: research, when-present: research),
    (value: v(-1.5em), when-present: "always"),
    (value: strong(underline(upper(subject-ru))), when-present: subject-ru),
    (value: v(-1.5em), when-present: "always"),
    (value: strong(underline(upper(subject))), when-present: subject),
    (value: v(-1.5em), when-present: "always"),
    (value: report-type, when-present: report-type),
    (value: [field of study #underline(field-of-study)], when-present: field-of-study),
    (value: [#study-level\'s Programme in #underline(study-programme)], when-present: (study-level, study-programme)),
    (
      value: [(#stage.type)],
      when-rule: (stage.type != none and stage.num == none),
    ),
    (
      value: [(#stage.type, stage #stage.num)],
      when-present: (stage.type, stage.num),
    ),
    (value: [\ Book #part], when-present: part),
  )
  
  if performer != none {
    let title = if type(performer.title) == str and manager.title != "" {
      performer.title + linebreak()
    } else {
      none
    }
    sign-field(
      performer.at("name", default: none),
      [#title #performer.at("position", default: none)],
      part: performer.at("part", default: none),
    )
  }

  if manager.name != none {
    let title = if type(manager.title) == str and manager.title != "" {
      manager.title + linebreak()
    } else {
      none
    }
    sign-field(manager.at("name"), [#title #manager.at("position")])
  }
  v(0.5fr)
}
