#import "BGLNotificationTableViewCell.h"

#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>

extern UIFont *bgl_titleFont(void);
extern UIFont *bgl_messageFont(void);

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

		self.titleLabel = [[UILabel alloc] init];
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.font = bgl_titleFont();
		self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.titleLabel.numberOfLines = 1;
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.titleLabel];
		[self addConstraints:@[
			[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10],
			[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10],
			[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-20]
		]];
		[self.titleLabel release];

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

}

- (BBBulletin *)bulletin {
	return _bulletin;
}

- (void)dealloc {
	[_bulletin release];
	[super dealloc];
}

@end