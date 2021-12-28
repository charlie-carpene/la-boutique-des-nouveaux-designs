import { Controller } from "@hotwired/stimulus";
import { uppyInstance, uploadedFileData, getErrorDetails } from '../uppy';
import { postShopImage } from '../ajax';
import spinner from '../../assets/spinner.gif';

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
      types: this.typesValue,
      size: this.sizeValue,
      server: this.serverValue,
    });
    
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
