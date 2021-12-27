export function postShopImage (path, fileData) {
  $.ajax({
    url: path,
    type: "PUT",
    dataType: 'json',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
    },
    data: { shop: { image: fileData } },
    success: function(data) { 
      $("img[data-single-upload-target='preview']")[0].src = data.url;
    },
    error: function(data) {
      alert(`Oops, the upload didn't work. Click 'OK' to reload the page then try again.\n\n---\n\nERROR MESSAGE (Status ${data.status}):\n\n${data.responseText}`);
      location.reload();
    }
  });
}
