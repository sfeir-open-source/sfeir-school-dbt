import {SfeirThemeInitializer} from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
  ];
}

function introSlides() {
  const directory = '00-intro';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-intro.md`,
    `${directory}/21-speaker-aal.md`,
    `${directory}/22-speaker-hmd.md`,
    `${directory}/30-who-are-you.md`
  ];
}
function outroSlides() {
  const directory = '99-outro';
  return [
    `${directory}/10-questions.md`,
    `${directory}/20-the-end.md`
  ];
}

function onceUponATimeSlides() {
  const directory = '10-once-upon-a-time';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-architectures.md`,
  ];
}

function dbtSlides() {
  const directory = '12-dbt';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-dbt.md`,
  ];
}

function installationSlides() {
  const directory = '15-installation';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-installation.md`,
    `${directory}/20-adapters.md`,
  ];
}

function projectSlides() {
  const directory = '20-project-structure';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-structure.md`,
    `${directory}/20-dbt_project.md`,
    `${directory}/30-profiles.md`,
  ];
}

function commandsSlides() {
  const directory = '25-commands';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-dbt-commands.md`,
    `${directory}/90-lab.md`
  ];
}

function modelsSlides() {
  const directory = '30-models';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-what-is-a-model.md`,
    `${directory}/20-materializations.md`,
    `${directory}/30-models-properties-file.md`,
    `${directory}/40-tags.md`,
    `${directory}/90-lab.md`,
  ];
}

function seedsSlides() {
  const directory = '35-seeds';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-seeds.md`,
    `${directory}/90-lab.md`,
  ];
}

function sourceAndRefSlides() {
  const directory = '40-source-and-ref';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-ref.md`,
    `${directory}/20-source.md`,
    `${directory}/30-docs.md`,
    `${directory}/90-lab.md`
  ];
}

function jinjaSlides() {
  const directory = '50-jinja-and-macros';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-jinja.md`,
    `${directory}/20-macros.md`,
    `${directory}/90-lab.md`
  ];
}

function qualitySlides() {
  const directory = '60-quality';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-always-test.md`,
    `${directory}/20-generic-tests.md`,
    `${directory}/30-singular-tests.md`,
    `${directory}/35-packages.md`,
    `${directory}/40-model-tests.md`,
    `${directory}/90-lab.md`
  ];
}

function advancedSlides() {
  const directory = '80-advanced';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-snapshots.md`,
    `${directory}/20-analyses.md`,
    `${directory}/30-hooks.md`,
    `${directory}/40-statement-blocks.md`,
    `${directory}/50-production.md`,
    `${directory}/60-artifacts.md`,
  ]
}

function formation() {
  return [
    //
    ...introSlides(), //

    ...onceUponATimeSlides(),//
    ...dbtSlides(),//
    ...installationSlides(), //
    ...projectSlides(), //
    ...commandsSlides(), //
    ...modelsSlides(), //
    ...seedsSlides(), //
    ...sourceAndRefSlides(), //
    ...jinjaSlides(), //
    ...qualitySlides(), //
    ...outroSlides(), //

    ...advancedSlides(), //

  ].map((slidePath) => {
    return {path: slidePath};
  });
}

SfeirThemeInitializer.init(formation);
