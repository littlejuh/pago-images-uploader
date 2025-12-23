#  Pagô Upload Handler


## Setup
- In your fav console, goes to the api folder following these next steps:
  - `cd pago-uploads`

### 🚀 Run the Project
The project provides a `Makefile` to simplify common tasks.

- Build(install dependencies):
  - `make build`
- Run PagoUploads application(in :9292 port):
  - `make run`
- Run tests:
  - `make test`
- Run static analysis(rubocop w/ automatic fix):
  - `make lint`  

### 🛠 Prerequisites
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

---

## 📄 API Documentation

This project follows the OpenAPI (Swagger) specification.

- OpenAPI file: [`docs/openapi.yaml`](docs/openapi.yaml)

You can visualize it using:
- Swagger Editor: https://editor.swagger.io
- Importing the file into Postman or Insomnia

## Context

This project implements an image upload and retrieval handler through a simple HTTP API.

The API is responsible for receiving image files, validating them, storing them locally (inside the application container volume), and making them available for retrieval through a public endpoint.

The flow starts in `HandlerController`, which exposes two HTTP entrypoints:

- `POST /upload/image` — uploads and validates an image
- `GET /static/image/:filename` — retrieves a previously uploaded image

If any other endpoint is accessed, the API should return `404 Not Found`.

### Upload Flow

The upload process starts at the `/upload/image` endpoint.  
This entrypoint receives a multipart request containing an image file and performs the following steps:

1. Validates the presence of the `image` parameter.
2. Validates the MIME type of the uploaded file.
3. Delegates the business logic to `ImageService`, which is responsible for:
   - Handling validations at the domain level
   - Persisting the image using a storage abstraction
   - Decoupling the controller from storage and infrastructure details

If the upload is successful, the API returns:

- HTTP `204 No Content`

Invalid requests (missing file, invalid MIME type, malformed input) result in:

- HTTP `400 Bad Request`

### Image Retrieval Flow

The `/static/image/:filename` endpoint allows clients to retrieve previously uploaded images.

The flow is as follows:

1. The controller receives the requested filename.
2. The request is delegated to `ImageService`.
3. The service attempts to read the image:
   - If the image exists, it returns the binary content.
   - If the image does not exist, it returns `nil`.

The controller then responds with:

- HTTP `200 OK` and the image content when found
- HTTP `404 Not Found` when the image does not exist

### Architectural Notes

- Controllers are kept minimal and focused only on HTTP concerns.
- Business rules and orchestration live in the service layer.
- Storage is abstracted, allowing easy replacement of local storage with an S3-compatible provider in the future.
- The application follows a modular structure inspired by hexagonal architecture principles.

> “Truth can only be found in one place: the code.”  
> — Robert C. Martin, *Clean Code*
