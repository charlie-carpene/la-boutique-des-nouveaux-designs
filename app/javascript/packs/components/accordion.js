const accordion = document.getElementsByClassName("accordion");

[...accordion].forEach((element) => {
  element.addEventListener("click", function() {
    element.classList.toggle("accordion-oppened");
  });
});
