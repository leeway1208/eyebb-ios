//
//  RootViewController.h
//  zcdh
//
//  Created by evan.Yan on 14-10-13.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "EyeBBViewController.h"
@interface RootViewController : EyeBBViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
      NSTimer * timer;
}
@property (nonatomic, retain) UIImageView * line;
@end
