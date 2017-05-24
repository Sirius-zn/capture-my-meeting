module MagickHelper
    # Convert image to black and white
    # @param image - Magick::Image or string with path to image
    # return Magick::Image in black and white
    def convert_to_black_and_white(image)
        return nil unless image.class == String || image.class == Image::Magick

        begin
            image = Magick::Image.read image if image.class == String
        rescue
            # path does not exist
        end

        # 2 indicates binary color, just black and white
        return image.quantize(2, Magick::GRAYColorspace, false)
    end
end
