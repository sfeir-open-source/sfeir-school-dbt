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
    `${directory}/30-profile.md`,
    `${directory}/40-packages.md`,
    `${directory}/90-lab.md`
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
    `${directory}/00-title.md`
  ];
}

function sourceAndRefSlides() {
  const directory = '40-source-and-ref';
  return [
    `${directory}/00-title.md`,
    `${directory}/10-ref.md`,
    `${directory}/10-source.md`
  ];
}


function formation() {
  return [
    //
    ...introSlides(), //

    ...installationSlides(), //
    ...projectSlides(), //
    ...commandsSlides(), //
    ...modelsSlides(), //
    ...sourceAndRefSlides(), //

    ...outroSlides(), //
  ].map((slidePath) => {
    return {path: slidePath};
  });
}

SfeirThemeInitializer.init(formation);
