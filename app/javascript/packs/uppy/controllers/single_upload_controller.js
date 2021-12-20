import { Controller } from "@hotwired/stimulus";
import { uppyInstance, uploadedFileData, getErrorDetails } from '../uppy';

export default class extends Controller {
  static targets = [ 'input', 'result', 'preview' ]
  static values = { types: Array, server: String }

  connect() {
    this.uppy = this.createUppy();
  };

  disconnect() {
    this.uppy.close();
  };

  createUppy() {
    const uppy = uppyInstance({
        id: this.inputTarget.id,
        types: this.typesValue,
        server: this.serverValue,
      })

    uppy.on('upload', () => {
      console.log('nothing happen');
    });

    uppy.on('upload-success', (file, response) => {
      this.resultTarget.value = uploadedFileData(file, response, this.serverValue);
      this.previewTarget.src = file.preview;
    });

    uppy.on('upload-error', (file, error, response) => {
      uppy.info({
        message: 'Oh no, something bad happened!',
        details: getErrorDetails(response.status),
      }, 'error', 5000)
    });
  
    return uppy
  }
}