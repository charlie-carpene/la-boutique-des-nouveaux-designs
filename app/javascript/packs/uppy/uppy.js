const Uppy = require('@uppy/core');
const XHRUpload = require('@uppy/xhr-upload');
const AwsS3 = require('@uppy/aws-s3');

require('@uppy/core/dist/style.css');

export function uppyInstance({ id, autoProceed, allowMultipleUploads, maxNumberOfFiles, types, size, server, uploader_type }) {
  document.getElementById(id).addEventListener('click', (event) => event.preventDefault());

  const uppy = new Uppy({
    id: id,
    autoProceed: autoProceed,
    allowMultipleUploads: allowMultipleUploads,
    logger: Uppy.debugLogger,
    restrictions: {
      maxNumberOfFiles: maxNumberOfFiles,
      maxFileSize: size,
      allowedFileTypes: types,
    },
    meta: {
      uploader_type: uploader_type
    }
  });

  if (server == 's3') {
    uppy.use(AwsS3, {
      limit: 2,
      timeout: 60000,
      companionUrl: '/',
      companionHeaders: {}
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
