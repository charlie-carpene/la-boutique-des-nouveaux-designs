const Uppy = require('@uppy/core');
const Dashboard = require('@uppy/dashboard');
const XHRUpload = require('@uppy/xhr-upload');

require('@uppy/core/dist/style.css');
require('@uppy/dashboard/dist/style.css');

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('[data-uppy]').forEach(element => setupUppy(element));
});

function setupUppy(element) {
  const trigger = document.getElementById('uppy-shop');

  trigger.addEventListener('click', (event) => event.preventDefault());

  const uppy = new Uppy({
    autoProceed: false,
    allowMultipleUploads: false,
    logger: Uppy.debugLogger,
    restrictions: {
      maxNumberOfFiles: 1,
      maxFileSize: 3*1024*1024,
      allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.png'],
    }
  })
  .use(Dashboard, {
    trigger: trigger,
    closeAfterFinish: true,
  }).use(XHRUpload, {
    endpoint: '/images/upload',
    limite: 0,
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
    }
  });
  
  uppy.on('upload-success', (file, response) => {
    let uploadedFileData = JSON.stringify(response.body);
    let hiddenField = document.querySelector('.attachment-field[type=hidden]');
    hiddenField.value = uploadedFileData;

    setPreview(element, file);
  });

  uppy.on('upload-error', (file, error, response) => {
    uppy.info({
      message: 'Oh no, something bad happened!',
      details: getErrorDetails(response.status),
    }, 'error', 5000)
  });
};

function setPreview(element, file) {
  let preview = element.querySelector('[data-behavior="uppy-shop-preview"]');
  if (preview) {
    preview.src = file.preview;
  };
};

function getErrorDetails (status) {
  const error = {
    '401': 'It looks like you don\'t have the rights to access this ressource',
    'default': `Contact us with the status code : ${status} so we can fix it.`
  };
  return error[status] || error['default'];
}
