/** Provides classes and predicates related to `androidx.slice`. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class SliceBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice.builders;ListBuilder;false;addAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;addGridRow;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addGridRow;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;addInputRange;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addInputRange;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;addRange;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addRange;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;addRating;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addRating;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;addRow;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addRow;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;addSelection;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addSelection;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setAccentColor;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setHeader;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;setHeader;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setHostExtras;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setIsError;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setKeywords;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setLayoutDirection;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setSeeMoreAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;setSeeMoreAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;setSeeMoreRow;;;Argument[0];Argument[-1];value",
        "androidx.slice.builders;ListBuilder;false;setSeeMoreRow;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder;false;build;;;Argument[-1];ReturnValue;taint",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setContentDescription;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setLayoutDirection;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setPrimaryAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setSubtitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setSummary;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setTitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;addEndItem;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;addEndItem;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setContentDescription;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setInputAction;(PendingIntent);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setInputAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setLayoutDirection;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setMax;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setMin;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setPrimaryAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setSubtitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setThumb;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setTitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setTitleItem;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setValue;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setContentDescription;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setMax;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setMode;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setPrimaryAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setSubtitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setTitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setTitleItem;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setValue;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setContentDescription;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setInputAction;(PendingIntent);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setInputAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setMax;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setMin;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setPrimaryAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setSubtitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setTitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setTitleItem;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setValue;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;addEndItem;(SliceAction,boolean);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;addEndItem;(SliceAction);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;addEndItem;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setContentDescription;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setEndOfSection;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setLayoutDirection;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setPrimaryAction;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setSubtitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setTitle;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setTitleItem;(SliceAction);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setTitleItem;(SliceAction,boolean);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setTitleItem;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;SliceAction;false;create;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;createDeeplink;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;createToggle;(PendingIntent,CharSequence,boolean);;Argument[0];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;getAction;;;Argument[-1];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;setChecked;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;SliceAction;false;setContentDescription;;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;SliceAction;false;setPriority;;;Argument[-1];ReturnValue;value"
      ]
  }
}

private class SliceProviderSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice;SliceProvider;true;onBindSlice;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onCreatePermissionRequest;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onMapIntentToUri;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onSlicePinned;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onSliceUnpinned;;;Parameter[0];contentprovider"
      ]
  }
}
