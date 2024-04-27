type DateStyle = Intl.DateTimeFormatOptions['dateStyle'];

export function formatDate(
	date: string,
	dateStyle: DateStyle = 'medium',
	locales = 'en'
) {
	if (!date) return ''

	const dateToFormat = Date.parse(date);
	const dateFormatter = new Intl.DateTimeFormat(locales, { dateStyle });
	try {
		return dateFormatter.format(dateToFormat);
	} catch (e) {
		console.log('Error formatting date: ', e);
		return dateToFormat;
	}
}
