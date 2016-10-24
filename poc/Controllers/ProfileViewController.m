
#import <DLRadioButton/DLRadioButton.h>

#import "ProfileViewController.h"
#import "Constants.h"
#import "User.h"
#import "NSDictionary-Expanded.h"
#import "RequestManager.h"
#import "AppManager.h"
#import "TextField.h"
#import "Button.h"

@interface ProfileViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet Button *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet TextField *nameTextField;
@property (weak, nonatomic) IBOutlet TextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet TextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet DLRadioButton *maleRadioButton;
@property (weak, nonatomic) IBOutlet DLRadioButton *femaleRadioButton;
@property (weak, nonatomic) IBOutlet UIView *profileImageContentView;

@end

@implementation ProfileViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isInitialProfile = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Perfil";
    self.screenName = @"Perfil";
    
    [self.profileImageContentView setHidden:_isInitialProfile];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

    
    User *user = [[AppManager sharedManager] currentUser];
    self.nameTextField.text = user.firstName;
    self.lastNameTextField.text = user.lastName;
    if (!isEmpty(user.birthday)) self.birthdayTextField.text = [[self dateFormatter] stringFromDate:user.birthday];    
    self.maleRadioButton.selected = user.isMale;
    self.femaleRadioButton.selected = user.isFemale;
}

#pragma mark actions

- (IBAction)onCancelPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    User *user = [AppManager sharedManager].currentUser;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.nameTextField.text forKey:@"nombre"];
    [params setObject:self.lastNameTextField.text forKey:@"apellido"];
    
    NSDate *birthday;
    if (!isEmpty(self.birthdayTextField.text))
    {
        birthday = [[self dateFormatter] dateFromString:self.birthdayTextField.text];
        [params setObject:[user dateToString:birthday] forKey:@"fecha_nacimiento"];
    }
    else
    {
        [params setObject:@"" forKey:@"fecha_nacimiento"];
    }

    if (self.maleRadioButton.selected)
    {
        [params setObject:@"M" forKey:@"sexo"];
    }
    else if (self.femaleRadioButton.selected)
    {
        [params setObject:@"F" forKey:@"sexo"];
    }
    
    NSLog(@"%@", params);
    
    [self.saveButton startLoading];
    [[RequestManager sharedManager] PUT:[NSString stringWithFormat:@"/api/usuarios/%@", user.uid] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [self.saveButton endLoading];
        
        NSString *error = [responseObject getStringForKey:@"error"];
        if (!isEmpty(error))
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ACEPTAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [[AppManager sharedManager] setCurrentUser:user];
            
            if (self.isInitialProfile)
            {
                [self.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"DrawerController"]] animated:YES];
            }
            else
            {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        [self.saveButton endLoading];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ACEPTAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark text field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1)
    {
        return NO;
    }
    else if (textField.keyboardType == UIKeyboardTypeNumberPad && string.length && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound)
    {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    if (textField.tag == 1)
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
        
        textField.inputView = datePicker;
//        textField.text = [[self dateFormatter] stringFromDate:picker.date];
    }
}

- (void)updateDateField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.activeTextField.inputView;
    self.activeTextField.text = [[self dateFormatter] stringFromDate:picker.date];
}

- (NSDateFormatter*)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    return dateFormatter;
}

@end
