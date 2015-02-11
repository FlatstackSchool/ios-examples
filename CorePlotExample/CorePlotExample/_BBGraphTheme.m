//
//  _BBGraphTheme.m
//  TrailSee
//
//  Created by Vladimir Goncharov on 04.09.14.
//  Copyright (c) 2014 FlatStack. All rights reserved.
//

#import "_BBGraphTheme.h"

NSString *const kBBTheme = @"Custom Theme";

@implementation _BBGraphTheme

+(void)load
{
    [self registerTheme:self];
}

+(NSString *)name
{
    return kBBTheme;
}

#pragma mark \

-(void)applyThemeToBackground:(CPTGraph *)graph
{
    CPTColor *color         = [CPTColor clearColor];
    graph.fill              = [CPTFill fillWithColor:color];
    
    graph.paddingLeft   = 0.0;
    graph.paddingTop    = 0.0;
    graph.paddingRight  = 0.0;
    graph.paddingBottom = 0.0;
}

-(void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{
    CPTColor *color         = [CPTColor colorWithComponentRed:40/255.0f
                                                        green:45/255.0f
                                                         blue:55/255.0f
                                                        alpha:1.0f];
    plotAreaFrame.fill = [CPTFill fillWithColor:color];
}

-(void)applyThemeToAxisSet:(CPTAxisSet *)axisSet
{
    for ( CPTXYAxis *axis in axisSet.axes )
    {
        CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
        gridLineStyle.lineCap   = kCGLineCapSquare;
        gridLineStyle.lineColor = [CPTColor colorWithComponentRed:0.8f green:0.8f blue:0.8f alpha:0.1f];
        gridLineStyle.lineWidth = CPTFloat(0.75f);
        axis.majorGridLineStyle = gridLineStyle;
        
        CPTMutableLineStyle *clearLineStyle = [CPTMutableLineStyle lineStyle];
        clearLineStyle.lineWidth = 0.0f;
        clearLineStyle.lineColor = [CPTColor clearColor];
        
        switch (axis.coordinate)
        {
            case CPTCoordinateX:
            {
                CPTMutableTextStyle *whiteTextStyle = [[CPTMutableTextStyle alloc] init];
                whiteTextStyle.color    = [CPTColor whiteColor];
                whiteTextStyle.fontSize = CPTFloat(10.0);
                
                NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
                newFormatter.minimumIntegerDigits  = 1;
                newFormatter.maximumFractionDigits = 2;
                newFormatter.minimumFractionDigits = 1;
                
                CPTConstraints *constaint  = [CPTConstraints constraintWithRelativeOffset:0.15f];
                
                axis.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
                axis.tickDirection               = CPTSignNone;
                axis.majorTickLineStyle          = clearLineStyle;
                axis.minorTickLineStyle          = clearLineStyle;
                axis.axisLineStyle               = clearLineStyle;
                axis.labelTextStyle              = whiteTextStyle;
                axis.axisConstraints             = constaint;
            }; break;
                
            case CPTCoordinateY:
            {
                CPTMutableTextStyle *blueTextStyle = [[CPTMutableTextStyle alloc] init];
                blueTextStyle.color    = [CPTColor colorWithComponentRed:75/255.0f
                                                                    green:140/255.0f
                                                                     blue:190/255.0f
                                                                    alpha:1.0f];
                blueTextStyle.fontSize = CPTFloat(10.0);
                
                NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
                newFormatter.minimumIntegerDigits  = 1;
                newFormatter.maximumFractionDigits = 0;
                newFormatter.minimumFractionDigits = 0;
                
                CPTConstraints *constaint  = [CPTConstraints constraintWithRelativeOffset:0.1f];
                
                axis.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
                axis.labelFormatter              = newFormatter;
                axis.tickDirection               = CPTSignNone;
                axis.majorTickLineStyle          = clearLineStyle;
                axis.minorTickLineStyle          = clearLineStyle;
                axis.axisLineStyle               = clearLineStyle;
                axis.labelTextStyle              = blueTextStyle;
                axis.axisConstraints             = constaint;
            }; break;
                
            default:
                break;
        }
    }
}

#pragma mark \
#pragma mark NSCoding Methods

-(Class)classForCoder
{
    return [CPTTheme class];
}

@end
