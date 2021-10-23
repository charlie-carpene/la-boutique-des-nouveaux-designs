class NbrOfPicturesValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		limit = 10
		if value.length == 0
			puts "*" * 30
			puts value.length
			puts "*" * 30
			record.errors.add("#{attribute}.no_picture", I18n.t("#{attribute}.errors.no_pictures_attached"))
		elsif value.length > limit
			puts "*" * 30
			puts "2"
			puts "*" * 30	
			record.errors.add("#{attribute}.picture_nbr", I18n.t("#{attribute}.errors.too_many_pictures_attached", limit: limit))
		else 
			puts "*" * 30
			puts "all good: #{value.length}"
			puts "*" * 30	
		end
	end
end
