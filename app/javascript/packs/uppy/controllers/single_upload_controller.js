import { Controller } from "@hotwired/stimulus";
import ImageEditor from '@uppy/image-editor';
import Dashboard from '@uppy/dashboard';
import { uppyInstance, uploadedFileData, getErrorDetails } from '../uppy';

import { postShopImage } from '../ajax';

import spinner from '../../assets/spinner.gif';

require('@uppy/image-editor/dist/style.css');
require('@uppy/dashboard/dist/style.css');

export default class extends Controller {
  static targets = [ 'input', 'result', 'preview' ]
  static values = { types: Array, size: Number, server: String }

  connect() {
    this.resultTarget.id = "shop_image";
    this.resultTarget.name = "shop[image]";
    this.uppy = this.createUppy();
  };

  disconnect() {
    this.uppy.close();
  };

  createUppy() {
    const uppy = uppyInstance({
      id: this.inputTarget.id,
      autoProceed: false,
      allowMultipleUploads: false,
      maxNumberOfFiles: 1,
      types: this.typesValue,
      size: this.sizeValue,
      server: this.serverValue,
    }).use(Dashboard, {
      trigger: this.inputTarget,
      closeAfterFinish: true,
      note: `image must be less than ${Math.round(this.sizeValue/1000000)} Mo`,
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
    
    uppy.setMeta({ uploader_type: 'image' });

    uppy.on('upload', (data) => {
      this.previewTarget.src = spinner;
    });

    uppy.on('upload-success', (file, response) => {
      this.resultTarget.value = uploadedFileData(file, response, this.serverValue);
      const path = location.pathname.replace('/edit','');
      const fileData = this.resultTarget.value;

      postShopImage(path, fileData);
    });

    uppy.on('upload-error', (file, error, response) => {
      uppy.info({
        message: 'Oh no, something went wrong!',
        details: getErrorDetails(response.status),
      }, 'error', 5000)
    });
  
    return uppy
  }
};
