export type RecentTracksResponse = {
	track: Track[]
	'@attr': Paging
}

export type Paging = {
	user: string
	totalPages: string
	page: string
	total: string
	perPage: string
}

export type Track = {
	mbid: string
	name: string
	url: string
	loved: number
	streamable: number
	image: TrackImage[]
	date: {
		uts: number
		'#text': string
	}
	'@attr': {
		nowplaying: boolean
	}
	artist: {
		name: string
		url: string
		image: TrackImage[]
		mbid: string
	}
	album: {
		mbid: string
		'#text': string
	}
}

type TrackImage = {
	size: string
	'#text': string
}
