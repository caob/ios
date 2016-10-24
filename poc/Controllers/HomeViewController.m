
#import "HomeViewController.h"

@import Charts;
@interface HomeViewController () <ChartViewDelegate>

@property (weak, nonatomic) IBOutlet PieChartView *pieChart;
@property (weak, nonatomic) IBOutlet UIButton *centersButton;
@property (weak, nonatomic) IBOutlet UIButton *inboxButton;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
    self.screenName = @"Home";
    
    [self.centersButton.titleLabel setNumberOfLines:0];
    [self.centersButton.imageView setContentMode:UIViewContentModeScaleAspectFit];    
    [self.inboxButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.pieChart.usePercentValuesEnabled = YES;
    self.pieChart.drawSlicesUnderHoleEnabled = NO;
    self.pieChart.holeRadiusPercent = 0;
    self.pieChart.transparentCircleRadiusPercent = 0.61;
    self.pieChart.chartDescription.enabled = NO;
    [self.pieChart setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    self.pieChart.drawCenterTextEnabled = NO;
    
    self.pieChart.drawHoleEnabled = NO;
    self.pieChart.rotationAngle = 0.0;
    self.pieChart.rotationEnabled = YES;
    self.pieChart.highlightPerTapEnabled = YES;
    
    ChartLegend *l = self.pieChart.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    [self setDataCount:3 range:5];
}


- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:@"sarasa"]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    dataSet.sliceSpace = 2.0;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    self.pieChart.data = data;
}

@end
