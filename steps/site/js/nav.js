(function () {
  var b = typeof base_url !== 'undefined' ? base_url : '.';
  var nav = document.querySelector('.wy-menu.wy-menu-vertical');
  if (!nav) return;

  nav.innerHTML =
    '<ul>' +
    '  <li class="toctree-l1"><a class="reference internal" href="' + b + '/index.html">SFEIR Institute - dbt</a></li>' +
    '</ul>' +

    '<p class="caption"><span class="caption-text">Module 3</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 3.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_03/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_03/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 4</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 4.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_04/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_04/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 5</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 5.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_05/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_05/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 6</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 6.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_06/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_06/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 7</span></p>' +
    '<ul>' +
    '<li class="toctree-l1"><a class="reference internal" href="#">Lab 7.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_07/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_07/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li>' +
    '<li class="toctree-l1"><a class="reference internal" href="#">Lab 7.2</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_07/lab-2/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_07/lab-2/SOLUTION.html">Solution</a></li></ul>' +
    '</li>' +
    '</ul>' +

    '<p class="caption"><span class="caption-text">Module 8</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 8.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_08/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_08/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 9</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 9.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_09/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_09/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 10</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 10.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_10/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_10/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 11</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 11.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_11/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_11/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 12</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 12.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_12/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_12/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>' +

    '<p class="caption"><span class="caption-text">Module 13</span></p>' +
    '<ul><li class="toctree-l1"><a class="reference internal" href="#">Lab 13.1</a>' +
    '<ul><li class="toctree-l2"><a class="reference internal" href="' + b + '/module_13/lab-1/index.html">Tasks</a></li>' +
    '<li class="toctree-l2"><a class="reference internal" href="' + b + '/module_13/lab-1/SOLUTION.html">Solution</a></li></ul>' +
    '</li></ul>';
})();
