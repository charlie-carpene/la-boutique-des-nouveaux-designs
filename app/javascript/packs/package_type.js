const letter_button = document.getElementById("package_type_letter");
const package_button = document.getElementById("package_type_package");

const width = document.getElementById("item_width");
const height = document.getElementById("item_height");
const depth = document.getElementById("item_depth");
let widthValue = width.value;
let heightValue = height.value;
let depthValue = depth.value;

letter_button.addEventListener("change", function(event) {
  widthValue = width.value;
  heightValue = height.value;
  depthValue = depth.value;

  width.readOnly = true;
  width.value = 0;
  width.style.cursor = "not-allowed";
  height.readOnly = true;
  height.value = 0;
  height.style.cursor = "not-allowed";
  depth.readOnly = true;
  depth.value = 0;
  depth.style.cursor = "not-allowed";
});

package_button.addEventListener("change", function(event) {
  width.readOnly = false;
  width.value = widthValue;
  width.style.cursor = null;
  height.readOnly = false;
  height.value = heightValue;
  height.style.cursor = null;
  depth.readOnly = false;
  depth.value = depthValue;
  depth.style.cursor = null;
});
