class MyUploadAdapter {
  constructor( loader, url ) {
    this.loader = loader
    this.url = url
  }

  upload() {
    return new Promise( ( resolve, reject ) => {
        this._initRequest();
        this._initListeners( resolve, reject );
        this._sendRequest();
    } );
  }

  abort() {
    if ( this.xhr ) {
      this.xhr.abort();
    }
  }

  // Initializes XMLHttpRequest listeners.
  _initListeners( resolve, reject ) {
    const xhr = this.xhr;
    const loader = this.loader;
    const genericErrorText = 'Couldn\'t upload file:' + ` ${ loader.file.name }.`;

    xhr.addEventListener( 'error', () => reject( genericErrorText ) );
    xhr.addEventListener( 'abort', () => reject() );
    xhr.addEventListener( 'load', () => {
      const response = xhr.response;

      // This example assumes the XHR server's "response" object will come with
      // an "error" which has its own "message" that can be passed to reject()
      // in the upload promise.
      //
      // Your integration may handle upload errors in a different way so make sure
      // it is done properly. The reject() function must be called when the upload fails.
      if ( !response || xhr.status >= 400 ) {
          return reject( response && response.error ? response.error.message : genericErrorText );
      }

      // If the upload is successful, resolve the upload promise with an object containing
      // at least the "default" URL, pointing to the image on the server.
      // This URL will be used to display the image in the content. Learn more in the
      // UploadAdapter#upload documentation.
      resolve( {
          default: response.url
      } );
    } );

    // Upload progress when it is supported. The FileLoader has the #uploadTotal and #uploaded
    // properties which are used e.g. to display the upload progress bar in the editor
    // user interface.
    if ( xhr.upload ) {
      xhr.upload.addEventListener( 'progress', evt => {
        if ( evt.lengthComputable ) {
          loader.uploadTotal = evt.total;
          loader.uploaded = evt.loaded;
        }
      } );
    }
  }

  // Initializes the XMLHttpRequest object using the URL passed to the constructor.
  _initRequest() {
      const xhr = this.xhr = new XMLHttpRequest();

      // Note that your request may look different. It is up to you and your editor
      // integration to choose the right communication channel. This example uses
      // the POST request with JSON as a data structure but your configuration
      // could be different.
      const content = document.querySelectorAll('meta[name=csrf-token]')[0].content
      xhr.open( 'POST', this.url, true );
      xhr.setRequestHeader('X-CSRF-Token', content)
      xhr.responseType = 'json';
  }

  _sendRequest() {
    // Prepare the form data.
    const data = new FormData();

    data.append( 'image[image]', this.loader.file);

    // Send the request.
    this.xhr.send( data );
  }
}

function MyCustomUploadAdapterPlugin( editor ) {
  editor.plugins.get( 'FileRepository' ).createUploadAdapter = ( loader ) => {
      // Configure the URL to the upload script in your back-end here!
      return new MyUploadAdapter( loader, '/refinery/images/upload' );
  };
}

visual_editor_init_interface_hook = function () {
  document.querySelectorAll( '.visual_editor.widest' ).forEach(function(current) {
    ClassicEditor
      .create( current, {
        extraPlugins: [ MyCustomUploadAdapterPlugin ],
      } )
      .catch( error => {
          console.error( error );
      } );
  })

}
