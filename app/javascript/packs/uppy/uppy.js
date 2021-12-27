const Uppy = require('@uppy/core');
const Dashboard = require('@uppy/dashboard');
const XHRUpload = require('@uppy/xhr-upload');
const ImageEditor = require('@uppy/image-editor');
const AwsS3 = require('@uppy/aws-s3');

require('@uppy/core/dist/style.css');
require('@uppy/dashboard/dist/style.css');
require('@uppy/image-editor/dist/style.css');

export function uppyInstance({ id, types, server }) {
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
  }).use(Dashboard, {
    trigger: trigger,
    closeAfterFinish: true,
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

  if (server == 's3') {
    uppy.use(AwsS3, {
      limit: 2,
      timeout: 60000,
      companionUrl: '/',
    })
  } else {
    uppy.use(XHRUpload, {
      endpoint: '/images/upload',
      limite: 0,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      }
    })
  }

  return uppy
};

export function uploadedFileData(file, response, server) {
  if (server == 's3') {
    const id = file.meta['key'].match(/^cache\/(.+)/)[1]; // object key without prefix

    return JSON.stringify(fileData(file, id))
  } else {
    return JSON.stringify(response.body)
  }
};

// constructs uploaded file data in the format that Shrine expects
function fileData(file, id) {
  return {
    id: id,
    storage: 'cache',
    metadata: {
      size:      file.size,
      filename:  file.name,
      mime_type: file.type,
    }
  }
};

export function getErrorDetails (status) {
  const error = {
    '401': 'It looks like you don\'t have the rights to access this ressource',
    'default': `Contact us with the status code : ${status} so we can fix it.`
  };
  return error[status] || error['default'];
};
