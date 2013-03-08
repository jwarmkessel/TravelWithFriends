/*
 * Copyright 2012 I.ndigo
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SFURLRequest.h"
#import "SFUtil.h"

@interface SFURLRequest (Private)

- (void)releaseObjects;

@end

@implementation SFURLRequest

+ (id)requestWithURL:(NSString *)url success:(void (^)(NSData *))successBlock failure:(void (^)(NSError *))failureBlock cancel:(void (^)())cancelBlock
{
    return [[[self alloc] initWithURL:url success:successBlock failure:failureBlock cancel:cancelBlock] autorelease];
}

- (id)initWithURL:(NSString *)url success:(void (^)(NSData *))successBlock failure:(void (^)(NSError *))failureBlock cancel:(void (^)())cancelBlock
{
    self = [self init];
    if (self) {
        // Create the request.
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        // create the connection with the request
        // and start loading the data
        _connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (_connection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            _receivedData = [[NSMutableData data] retain];
            
            _successBlock = [successBlock copy];
            _failureBlock = [failureBlock copy];
            _cancelBlock = [cancelBlock copy];
            
            [self retain];
        } else {
            
            // Connection failed.
            failureBlock(SFError(@"Could not create connection"));
        }
    }
    return self;
}


- (void)cancel
{
    if (_connection) {
        [_connection cancel];
        
        if (_cancelBlock) {
            _cancelBlock();
        }
        
        [self releaseObjects];
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [_connection release];
    [_receivedData release];
    [_successBlock release];
    [_failureBlock release];
    [_cancelBlock release];
    
    [super dealloc];
}

#pragma mark - Private

/**
 * Release retained objects
 * SHOULD CALL NOTHING AFTER THIS METHOD
 */
- (void)releaseObjects
{
    [_connection release], _connection = nil;
    [_receivedData release], _receivedData = nil;
    [_successBlock release], _successBlock = nil;
    [_failureBlock release], _failureBlock = nil;
    [_cancelBlock release], _cancelBlock = nil;
    
    [self release];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"This should be used by SFSocialfacebook to get the response from FB: %@", response);
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_successBlock) {
        _successBlock(_receivedData);
    }
    
    [self releaseObjects];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Connection failed
    if (_failureBlock) {
        _failureBlock(error);
    }
    
    SFDLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [self releaseObjects];
}

@end
