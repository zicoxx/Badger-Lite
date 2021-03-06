#import "BGLNotificationTableViewCell.h"

#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>

extern UIFont *bgl_titleFont(void);
extern UIFont *bgl_messageFont(void);
extern UIFont *bgl_dateFont(void);

static NSString *bgl_dateStringForDate(NSDate *date) {

	NSCalendar *calendar = [NSCalendar currentCalendar];

	if([calendar isDateInToday:date]) { // This notification is from today; give the time
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.timeStyle = NSDateFormatterShortStyle;
		formatter.dateStyle = NSDateFormatterNoStyle;
		NSString *text = [[formatter stringFromDate:date] lowercaseString];
		[formatter release];
		return text;
	} else {
		// Thanks to http://stackoverflow.com/a/4739650
		NSDate *fromDate;
		NSDate *toDate;

		NSCalendar *calendar = [NSCalendar currentCalendar];

		[calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:date];
		[calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];

		NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];

		NSInteger days = [difference day];

		if(days == 1) {
			return @"yesterday";
		} else if(days <=6) {
			return [NSString stringWithFormat:@"%ld days ago", (long)days];
		} else {
			float weeks = floor(days/7);
			NSString *s = weeks == 1 ? @"" : @"s";
			return [NSString stringWithFormat:@"%0.0f week%@ ago", weeks, s];
		}
	}
	return @"";

}

@implementation BGLNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

		self.messageLabel = [[UILabel alloc] init];
		self.messageLabel.textColor = [UIColor whiteColor];
		self.messageLabel.font = bgl_messageFont();
		self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
		self.messageLabel.numberOfLines = 0;
		self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.messageLabel];
		[self addConstraints:@[
			[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10],
			[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10],
			[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-20]
		]];
		[self.messageLabel release];

		self.dateLabel = [[UILabel alloc] init];
		self.dateLabel.textColor = [UIColor whiteColor];
		self.dateLabel.font = bgl_dateFont();
		self.dateLabel.numberOfLines = 1;
		self.dateLabel.textAlignment = NSTextAlignmentRight;
		self.dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.dateLabel];
		[self addConstraints:@[
			[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10],
			[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-10],
			[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.3 constant:-10]
		]];


		self.titleLabel = [[UILabel alloc] init];
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.font = bgl_titleFont();
		self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.titleLabel.numberOfLines = 1;
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.titleLabel];
		[self addConstraints:@[
			[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0],
			[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10],
			[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.7 constant:-20]
		]];

		self.selectionStyle = UITableViewCellSelectionStyleNone;

	}

	return self;

}

- (void)setBulletin:(BBBulletin *)bulletin {

	if(_bulletin) [_bulletin release];
	_bulletin = [bulletin retain];
	self.messageLabel.text = bulletin.message;
	NSString *text = bulletin.title ?: bulletin.subtitle;
	if(!text) {
		SBApplication *application = [((SBApplicationController *)[%c(SBApplicationController) sharedInstance]) applicationWithBundleIdentifier:bulletin.section];
		text = application.displayName;
	}
	self.titleLabel.text = text;
	self.dateLabel.text = bgl_dateStringForDate(bulletin.date);

}

- (BBBulletin *)bulletin {
	return _bulletin;
}

- (void)dealloc {
	[self.titleLabel release];
	[_bulletin release];
	[super dealloc];
}

@end