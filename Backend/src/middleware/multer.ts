import multer from 'multer'

// Settings


const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, './users')
    },
    filename: function (req, file, cb) {
        req.body.filename = file.originalname;
        req.body.tipe = file.mimetype;

        
      cb(null, file.originalname)
    }
  })


export default multer({storage});