import {SfeirThemeInitializer} from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
  ];
}

function introSlides() {
  return [
    '00-intro/00-title.md',
    '00-intro/10-intro.md',
    '00-intro/21-speaker-aal.md',
    '00-intro/22-speaker-hmd.md',
    '00-intro/30-who-are-you.md'
  ];
}
function outroSlides() {
  return [
    '99-outro/10-questions.md',
    '99-outro/20-the-end.md'
  ];
}

function formation() {
  return [
    //
    ...introSlides(), //

    ...outroSlides(), //
  ].map((slidePath) => {
    return {path: slidePath};
  });
}

SfeirThemeInitializer.init(formation);
