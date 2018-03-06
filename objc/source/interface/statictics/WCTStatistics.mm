/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <WCDB/Database.hpp>
#import <WCDB/WCTError+Private.h>
#import <WCDB/WCTStatistics.h>

@implementation WCTStatistics

+ (void)SetGlobalErrorReport:(WCTErrorReportCallback)report
{
    if (report) {
        WCDB::Error::SetReportMethod([report](const WCDB::Error &error) {
            report([WCTError errorWithWCDBError:error]);
        });
    } else {
        WCDB::Error::SetReportMethod(nullptr);
    }
}

+ (void)SetGlobalPerformanceTrace:(WCTPerformanceTraceCallback)trace
{
    if (trace) {
        WCDB::BuiltinConfig::SetGlobalPerformanceTrace([trace](const std::map<const std::string, unsigned int> &footprint,
                                                               const int64_t &cost) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            for (const auto &iter : footprint) {
                [dictionary setObject:@(iter.second)
                               forKey:@(iter.first.c_str())];
            }
            trace(dictionary, (NSUInteger) cost);
        });
    } else {
        WCDB::BuiltinConfig::SetGlobalPerformanceTrace(nullptr);
    }
}

+ (void)SetGlobalSQLTrace:(WCTSQLTraceCallback)trace
{
    if (trace) {
        WCDB::BuiltinConfig::SetGlobalSQLTrace([trace](const std::string &sql) {
            trace(@(sql.c_str()));
        });
    } else {
        WCDB::BuiltinConfig::SetGlobalSQLTrace(nullptr);
    }
}

+ (void)ResetGlobalErrorReport
{
    WCDB::Error::ResetReportMethod();
}

@end
