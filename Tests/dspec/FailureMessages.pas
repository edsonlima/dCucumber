(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * Contributor(s):
 * Jody Dawkins <jdawkins@delphixtreme.com>
 *)

unit FailureMessages;

interface

const
  SpecNotApplicable = 'Not applicable to this specification';

  SpecIntegerShouldEqual = '<%d> should equal <%d> but didn''t';
  SpecIntegerShouldNotEqual = '<%d> should not equal <%d> but did';
  SpecIntegerShouldBeGreaterThan = '<%d> should be greater than <%d> but wasn''t';
  SpecIntegerShouldBeLessThan = '<%d> should be less than <%d> but wasn''t';
  SpecIntegerShouldBeAtLeast = '<%d> should be at least <%d> but wasn''t';
  SpecIntegerShouldBeAtMost = '<%d> should be at most <%d> but wasn''t';
  SpecIntegerShouldBeOdd = '<%d> should be odd but wasn''t';
  SpecIntegerShouldBeEven = '<%d> should be even but wasn''t';
  SpecIntegerShouldBePositive = '<%d> should be positive but wasn''t';
  SpecIntegerShouldBeNegative = '<%d> should be negative but wasn''t';
  SpecIntegerShouldBePrime = '<%d> should be prime but wasn''t';
  SpecIntegerShouldBeComposite = '<%d> should be composite but wasn''t';
  SpecIntegerShouldBeZero = '<%d> should be zero but wasn''t';
  SpecIntegerShouldBeNonZero = '<%d> should be non-zero but wasn''t';

  SpecStringShouldEqual = '<%s> should equal <%s> but didn''t';
  SpecStringShouldNotEqual = '<%s> should not equal <%s> but did';
  SpecStringShouldMatch = '<%s> should match <%s> but didn''t';
  SpecStringShouldBeNumeric = '<%s> should be numeric but wasn''t';
  SpecStringShouldBeAlpha = '<%s> should be alpha but wasn''t';
  SpecStringShouldBeAlphaNumeric = '<%s> should be alpha-numeric but wasn''t';
  SpecStringShouldStartWith = '<%s> should start with <%s> but didn''t';
  SpecStringShouldContain = '<%s> should contain <%s> but didn''t';
  SpecStringShouldEndWith = '<%s> should end with <%s> but didn''t';
  SpecStringShouldBeEmpty = '<%s> should be empty but wasn''t';

  SpecFloatShouldEqual = '<%g> should equal <%g> but didn''t';
  SpecFloatShouldNotEqual = '<%g> should not equal <%g> but did';
  SpecFloatShouldBeGreaterThan = '<%g> should be greater than <%g> but wasn''t';
  SpecFloatShouldBeLessThan = '<%g> should be less than <%g> but wasn''t';
  SpecFloatShouldBeAtLeast = '<%g> should be at least <%g> but wasn''t';
  SpecFloatShouldBeAtMost = '<%g> should be at most <%g> but wasn''t';
  SpecFloatShouldBePositive = '<%g> should be positive but wasn''t';
  SpecFloatShouldBeNegative = '<%g> should be negative but wasn''t';
  SpecFloatShouldBeZero = '<%g> should be zero but wasn''t';

  SpecDateTimeShouldBeGreaterThan = '<%s> should be greater than <%s> but wasn''t';
  SpecDateTimeShouldBeLessThan = '<%s> should be less than <%s> but wasn''t';
  SpecDateTimeShouldBeAtLeast = '<%s> should be at least <%s> but wasn''t';
  SpecDateTimeShouldBeAtMost = '<%s> should be at most <%s> but wasn''t';

  SpecPointerShouldBeNil = 'Pointer should be <nil> but wasn''t';
  SpecPointerShouldNotBeNil = 'Pointer should be <assigned> but wasn''t';
  SpecPointerShouldBeAssigned = 'Pointer should be <assigned> but wasn''t';

  SpecObjectShouldBeOfType = '<%s> should be of type <%s> but wasn''t';
  SpecObjectShouldNotBeOfType = '<%s> should not be of type <%s> but was';
  SpecObjectShouldDescendFrom = '<%s> should descend from <%s> but didn''t';
  SpecObjectShouldNotDescendFrom = '<%s> should not descend from <%s> but did';
  SpecObjectShouldBeAssigned = 'Object should be <assigned> but wasn''t';
  SpecObjectShouldImplement = '<%s> should implement interface <%s> but didn''t';
  SpecObjectShouldSupport = '<%s> should support interface <%s> but didn''t';

  SpecInterfaceShouldSupport = 'Interface should support <%s> but didn''t';
  SpecInterfaceShouldBeAssigned = 'Interface should be <assigned> but wasn''t';
  SpecInterfaceShouldBeNil = 'Interface should be nil but wasn''t';
  SpecInterfaceImplementingObjectNotFound = 'No implementing object could be found';
  SpecInterfaceShouldBeImplementedBy = 'Interface should be implemented by <%s> but wasn''t';

  ModNotApplicable = 'Not applicable to this modification';
  ModToleranceExceeded = '%s - exceeded tolerance of %g';
  ModCaseInsenstiveMatch = '%s - even ignoring case';
  ModPercentFailure = '%s - while evaluating percentage';

implementation

end.
