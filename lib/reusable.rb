module Reusable
	def translate_month(number)
		case number
		when 1
			return I18n.t("reusable.month.january")
		when 2
			return I18n.t("reusable.month.february")
		when 3
			return I18n.t("reusable.month.march")
		when 4
			return I18n.t("reusable.month.april")
		when 5
			return I18n.t("reusable.month.mai")
		when 6
			return I18n.t("reusable.month.june")
		when 7
			return I18n.t("reusable.month.july")
		when 8
			return I18n.t("reusable.month.august")
		when 9
			return I18n.t("reusable.month.september")
		when 10
			return I18n.t("reusable.month.october")
		when 11
			return I18n.t("reusable.month.november")
		when 12
			return I18n.t("reusable.month.december")
		else
			return I18n.t("reusable.month.error")
		end
	end
end
