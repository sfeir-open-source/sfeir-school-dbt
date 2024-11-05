import { SfeirThemeInitializer } from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [];
}

function introSlides() {
  const directory = '00-intro';
  return [
    `${directory}/00-title.md`,
    `${directory}/01-logistic.md`,
    `${directory}/10-intro.md`,
    `${directory}/11-agenda-day1.md`,
    `${directory}/12-agenda-day2.md`,
    `${directory}/21-speaker-aal.md`,
    `${directory}/22-speaker-hmd.md`,
    `${directory}/30-who-are-you.md`,
  ];
}
function outroSlides() {
  const directory = '99-outro';
  return [`${directory}/10-questions.md`, `${directory}/20-the-end.md`];
}

function onceUponATimeSlides() {
  const directory = '10-once-upon-a-time';
  return [`${directory}/00-title.md`, `${directory}/10-architectures.md`];
}

function dbtSlides() {
  const directory = '12-dbt';
  return [`${directory}/00-title.md`, `${directory}/10-dbt.md`];
}

function installationSlides() {
  const directory = '15-installation';
  return [`${directory}/00-title.md`, `${directory}/10-installation.md`, `${directory}/20-adapters.md`];
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
  return [`${directory}/00-title.md`, `${directory}/10-dbt-commands.md`, `${directory}/90-lab.md`];
}

function modelsSlides() {
  const directory = '30-models';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-what-is-a-model.md`,
    `${directory}/20-materializations.md`,
    `${directory}/90-lab.md`,
    `${directory}/30-advanced-materializations.md`,
    `${directory}/40-tags.md`,
  ];
}

function seedsSlides() {
  const directory = '45-seeds';
  return [`${directory}/00-title.md`, `${directory}/10-seeds.md`, `${directory}/90-lab.md`];
}

function sourceAndRefSlides() {
  const directory = '40-source-and-ref';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-source.md`,
    `${directory}/20-ref.md`,
    `${directory}/30-filters.md`,
    `${directory}/40-freshness.md`,
    `${directory}/90-lab.md`,
  ];
}

function historicalDataSlides() {
  const directory = '50-historical-data';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-snapshots.md`,
    `${directory}/20-snapshots-definition.md`,
    `${directory}/30-snapshots-exec-and-manage.md`,
    `${directory}/90-lab.md`,
  ];
}

function packageDependanciesSlides() {
  const directory = '70-package-dependancies';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-packages.md`,
    `${directory}/20-hub.md`,
    `${directory}/30-installing.md`,
    `${directory}/40-build.md`,
    `${directory}/90-lab.md`,
  ];
}

function advancedSlides() {
  const directory = '60-advanced';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-jinja.md`,
    `${directory}/20-macros.md`,
    `${directory}/30-templating.md`,
    `${directory}/90-lab.md`,
  ];
}

function testingSlides() {
  const directory = '80-testing';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-testing.md`,
    `${directory}/15-choose-testing.md`,
    `${directory}/16-lab.md`,
    `${directory}/20-unit.md`,
    `${directory}/30-automated.md`,
  ];
}

function contractAndVersionsSlides() {
  const directory = '90-contracts';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-contracts.md`,
    `${directory}/20-keys.md`,
    `${directory}/30-versions.md`,
    `${directory}/90-lab.md`,
  ];
}

function formation() {
  return [
    //
    ...introSlides(), //

    ...onceUponATimeSlides(), //
    ...dbtSlides(), //
    ...installationSlides(), //
    ...projectSlides(), //
    ...commandsSlides(), //
    ...modelsSlides(), //
    ...sourceAndRefSlides(), //
    ...seedsSlides(), //
    ...historicalDataSlides(), //
    ...advancedSlides(), //
    ...packageDependanciesSlides(), //
    ...testingSlides(), //
    ...contractAndVersionsSlides(), //
    ...outroSlides(), //

    ...advancedSlides(), //
  ].map((slidePath) => {
    return { path: slidePath };
  });
}

SfeirThemeInitializer.init(formation);
