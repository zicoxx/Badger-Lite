NSString *const kBGLNotificationCellReuseIdentifier = @"com.bflatstudios.badger-lite/notificationCell";

UIFont *bgl_messageFont(void) {
	return [UIFont systemFontOfSize:16];
}

UIFont *bgl_titleFont(void) {
	return [UIFont systemFontOfSize:20];
}

UIFont *bgl_dateFont(void) {
	return [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
}
