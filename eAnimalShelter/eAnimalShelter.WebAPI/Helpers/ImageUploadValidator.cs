using eAnimalShelter.Model.Exceptions;

namespace eAnimalShelter.WebAPI.Helpers
{
    public static class ImageUploadValidator
    {
        public const long MaxFileSize = 5 * 1024 * 1024; // 5 MB

        private static readonly string[] AllowedExtensions =
        {
            ".jpg",
            ".jpeg",
            ".png",
            ".webp"
        };

        private static readonly string[] AllowedMimeTypes =
        {
            "image/jpeg",
            "image/png",
            "image/webp"
        };

        public static async Task ValidateAsync(IFormFile file)
        {
            if (file == null || file.Length == 0)
                throw new ClientException("Image is required.");

            if (file.Length > MaxFileSize)
                throw new ClientException("Maximum allowed image size is 5 MB.");

            var extension = Path.GetExtension(file.FileName).ToLowerInvariant();

            if (!AllowedExtensions.Contains(extension))
                throw new ClientException("Only JPG, JPEG, PNG and WEBP images are allowed.");

            if (!AllowedMimeTypes.Contains(file.ContentType.ToLower()))
                throw new ClientException("Invalid image type.");

            using var stream = file.OpenReadStream();

            byte[] buffer = new byte[12];

            await stream.ReadAsync(buffer);

            if (!IsValidImage(buffer))
                throw new ClientException("Uploaded file is not a valid image.");
        }

        private static bool IsValidImage(byte[] bytes)
        {
            // JPG
            if (bytes[0] == 0xFF &&
                bytes[1] == 0xD8 &&
                bytes[2] == 0xFF)
                return true;

            // PNG
            if (bytes[0] == 0x89 &&
                bytes[1] == 0x50 &&
                bytes[2] == 0x4E &&
                bytes[3] == 0x47)
                return true;

            // WEBP (RIFF....WEBP)
            if (bytes[0] == 0x52 &&
                bytes[1] == 0x49 &&
                bytes[2] == 0x46 &&
                bytes[3] == 0x46 &&
                bytes[8] == 0x57 &&
                bytes[9] == 0x45 &&
                bytes[10] == 0x42 &&
                bytes[11] == 0x50)
                return true;

            return false;
        }

        public static string GenerateFileName(IFormFile file)
        {
            var extension = Path.GetExtension(file.FileName).ToLowerInvariant();

            return $"{Guid.NewGuid()}{extension}";
        }
    }
}