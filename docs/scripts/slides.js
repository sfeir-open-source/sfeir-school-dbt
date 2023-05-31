import {SfeirThemeInitializer} from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
  ];
}

function introSlides() {
  return [
    '00-school/00-title.md',
    '00-school/10-intro.md',
    '00-school/21-speaker-aal.md',
    '00-school/22-speaker-hmd.md',
    '00-school/30-who-are-you.md'
  ];
}

function formation() {
  return [
    //
    ...introSlides(), //
    // ...schoolSlides(), //
  ].map((slidePath) => {
    return {path: slidePath};
  });
}

SfeirThemeInitializer.init(formation);
