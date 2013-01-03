/*!
 * \file MHLazyTableImages.m
 *
 * Copyright (c) 2010-2011 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHLazyTableImages.h"
#import "MHImageCache.h"
#import "MessageCell.h"

@implementation MessageCell (MHLazyTableImages)

- (void)didLoadLazyImage:(UIImage*)theImage
{
	if (theImage != nil)
		self.headImage.image = theImage;
}

@end

@implementation MHLazyTableImages

@synthesize delegate, tableView, placeholderImage;

- (void)dealloc
{
	[placeholderImage release];
	[super dealloc];
}

- (UIImage*)imageForURL:(NSURL*)url
{
	return [[MHImageCache sharedInstance] cachedImageWithURL:url];
}

- (void)startDownload:(NSURL*)url indexPath:(NSIndexPath*)indexPath
{
	[[MHImageCache sharedInstance] imageFromURL:url cacheInFile:NO usingBlock:^(UIImage* image)
	{
		if (tableView != nil)
		{
			if (image != nil && [delegate respondsToSelector:@selector(postProcessLazyImage:forIndexPath:)])
			{
				UIImage* newImage = [delegate postProcessLazyImage:image forIndexPath:indexPath];
				if (newImage != image)
				{
					[[MHImageCache sharedInstance] cacheImage:newImage withURL:url];
					image = newImage;
				}
			}

			id<MHLazyTableImageCell> cell = [tableView cellForRowAtIndexPath:indexPath];
			[cell didLoadLazyImage:image];
		}
	}];
}

- (void)addLazyImageForCell:(id<MHLazyTableImageCell>)cell withIndexPath:(NSIndexPath*)indexPath
{
	NSURL* url = [delegate lazyImageURLForIndexPath:indexPath];
	if (url != nil)
	{
		UIImage* image = [self imageForURL:url];
		if (image != nil)
		{
			[cell didLoadLazyImage:image];
		}
		else
		{
			[cell didLoadLazyImage:self.placeholderImage];

			// Defer new downloads until scrolling ends
			if (tableView.dragging == NO && tableView.decelerating == NO)
				[self startDownload:url indexPath:indexPath];
		}
	}
}

- (void)loadImagesForOnscreenRows
{
	NSArray* visiblePaths = [tableView indexPathsForVisibleRows];
	for (NSIndexPath* indexPath in visiblePaths)
	{
		NSURL* url = [delegate lazyImageURLForIndexPath:indexPath];
		if (url != nil)
		{
			UIImage* image = [self imageForURL:url];
			if (image == nil)
			{
				// NOTE: scrolling may trigger an image lookup several times
				// for the same index path. The image cache already knows how
				// to handle multiple requests for the same image, but we could
				// save some overhead by keeping track of which index-paths are
				// currently downloading images.

				[self startDownload:url indexPath:indexPath];
			}
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	// Load images for all on-screen rows when scrolling is finished
	if (!decelerate)
		[self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	[self loadImagesForOnscreenRows];
}

@end
