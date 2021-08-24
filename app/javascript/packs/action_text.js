let attachmentButton = document.getElementsByClassName("trix-button--icon-attach");

attachmentButton[0].addEventListener('pointerdown', event => {
	event.preventDefault();
	alert("File attachment not supported!");
})