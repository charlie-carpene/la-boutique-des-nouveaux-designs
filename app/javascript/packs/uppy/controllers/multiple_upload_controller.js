import { Controller } from "@hotwired/stimulus";
import ImageEditor from '@uppy/image-editor';
import Dashboard from '@uppy/dashboard';
import { uppyInstance, uploadedFileData, getErrorDetails } from '../uppy';
import { nanoid } from 'nanoid';

require('@uppy/image-editor/dist/style.css');
require('@uppy/dashboard/dist/style.css');

export default class extends Controller {
  static targets = [ 'input', 'upload' ]
  static values = { types: Array, size: Number, server: String }

  connect() {
    if (this.element.lastChild.tagName !== 'DIV') {
      this.createDashboardDiv();
    };
    this.uppy = this.createUppy();
  };

  disconnect() {
    this.uppy.close();
  };

  createUppy() {
    const uppy = uppyInstance({
      id: this.inputTarget.id,
      autoProceed: false,
      allowMultipleUploads: true,
      maxNumberOfFiles: 10,
      types: this.typesValue,
      size: this.sizeValue,
      server: this.serverValue,
      uploader_type: 'picture',
    }).use(Dashboard, {
      target: this.uploadTarget,
      hideUploadButton: true,
      disableStatusBar: true,
      autoOpenFileEditor: true,
      inline: true,
      width: 'auto',
      closeAfterFinish: false,
      note: `Image must be less than ${Math.round(this.sizeValue/1000000)} Mo. To be uploaded one by one if you wish to modify each of them.`,
    }).use(ImageEditor, {
      target: Dashboard,
      quality: 0.8,
      cropperOptions: {
        viewMode: 1,
        modal: false,
        aspectRatio: 1
      },
      actions: {
        granularRotate: false,
        cropSquare: false,
        cropWidescreen: false,
        cropWidescreenVertical: false,
      }
    });

    this.inputTarget.remove();

    uppy.on('file-editor:complete', (uploadedFile) => {
      uppy.upload();
    });

    uppy.on('upload-success', (file, response) => {

      const hiddenField = document.createElement('input');

      hiddenField.type = 'hidden';
      hiddenField.name = `item[item_pictures_attributes][${nanoid()}][picture]`;
      hiddenField.value = uploadedFileData(file, response, this.serverValue);

      this.element.appendChild(hiddenField);
    });

    uppy.on('upload-error', (file, error, response) => {
      uppy.info({
        message: 'Oh no, something went wrong!',
        details: getErrorDetails(response.status),
      }, 'error', 5000)
    });
  
    return uppy
  };

  createDashboardDiv() {
    const div = document.createElement('div');
    div.setAttribute('id', 'upload');
    div.setAttribute('data-multiple-upload-target', "upload");
    div.style.margin = '0.5rem auto';

    this.element.appendChild(div);
  };

  deleteDashboardDiv() {
    this.element.lastChild.remove();
  };
};
