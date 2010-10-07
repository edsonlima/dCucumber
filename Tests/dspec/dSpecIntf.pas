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
 
unit dSpecIntf;

interface

type
  IAutoDoc = interface
    function GetEnabled : Boolean;
    procedure SetEnabled(Value : Boolean);
    property Enabled : Boolean read GetEnabled write SetEnabled;
    function BeginSpec(const ContextName, SpecName : string) : string;
    function DocSpec(const Spec : string) : string;
  end;

  IContext = interface
  ['{71A6A1FA-B9FB-4216-BA49-74E6654DACA7}']
    function GetAutoDoc : IAutoDoc;
    procedure SetAutoDoc(const Value: IAutoDoc);
    function GetContextDescription : string;
    procedure SetContextDescription(const Value : string);
    property AutoDoc : IAutoDoc read GetAutoDoc write SetAutoDoc;
    property ContextDescription : string read GetContextDescription write SetContextDescription;
    procedure AddFailure(const AMessage : string; ACallerAddress : Pointer);
    procedure ReportFailures;
    procedure RepealLastFailure;
    procedure NewSpecDox(const ValueName : string);
    procedure DocumentSpec(Value : Variant; const SpecName : string);
  end;

  IModifier = interface;

  IBeHelper = interface
  ['{2DDDEB76-28DE-44D8-A438-5434473D952B}']
    function OfType(Expected : TClass) : IModifier;
    function Nil_ : IModifier;
    function True : IModifier;
    function False : IModifier;
    function GreaterThan(Expected : Variant) : IModifier;
    function LessThan(Expected : Variant) : IModifier;
    function AtLeast(Expected : Variant) : IModifier;
    function AtMost(Expected : Variant) : IModifier;
    function Assigned : IModifier;
    function ImplementedBy(Expected : TClass) : IModifier;
    function Numeric : IModifier;
    function Alpha : IModifier;
    function AlphaNumeric : IModifier;
    function Odd : IModifier;
    function Even : IModifier;
    function Positive : IModifier;
    function Negative : IModifier;
    function Prime : IModifier;
    function Composite : IModifier;
    function Zero : IModifier;
    function Empty : IModifier;
  end;

  IShouldHelper = interface
  ['{CBE9BC3E-298A-4BE0-A8B8-B5ABDB3BD0AC}']
    function CreateNewShouldHelper(Negated : Boolean) : IShouldHelper;
    function Not_ : IShouldHelper;
    function Be : IBeHelper;
    function Equal(Expected : Variant) : IModifier;
    function DescendFrom(Expected : TClass) : IModifier;
    function Implement(Expected : TGUID) : IModifier;
    function Support(Expected : TGUID) : IModifier;
    function StartWith(Expected : Variant) : IModifier;
    function Contain(Expected : Variant) : IModifier;
    function EndWith(Expected : Variant) : IModifier;
  end;

  ISpecifier = interface
  ['{DB598EEF-401E-42EB-B193-EB8D7D28B6F9}']
    function Should : IShouldHelper;
  end;

  IModifier = interface
  ['{2F8C42C7-50D8-4FC1-B5AE-1B126B4DA5C5}']
    function Unless(Condition : Boolean) : IModifier;
    function WithAToleranceOf(Value : Extended) : IModifier;
    function Percent : IModifier;
    function IgnoringCase : IModifier;
    function And_ : IShouldHelper;
  end;

implementation

end.
