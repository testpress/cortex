import 'dart:io';

void main() async {
  final keysEn = '''
  "forumErrorFailedToCreatePost": "Failed to create post",
  "forumErrorDiscussionNotFound": "Discussion not found",
  "forumErrorLoadingComments": "Error loading comments",
  "forumCommentsEmptyTitle": "No Comments Yet",
  "forumCommentsEmptySubtitle": "Be the first to reply to this thread.",
  "forumRepliesCount": "{count,plural, =1{1 Reply} other{{count} Replies}}",
  "@forumRepliesCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },
  "forumRoleInstructor": "Instructor",
  "forumErrorFailedToPostReply": "Failed to post reply"
}''';

  final keysAr = '''
  "forumErrorFailedToCreatePost": "فشل في إنشاء المنشور",
  "forumErrorDiscussionNotFound": "النقاش غير موجود",
  "forumErrorLoadingComments": "خطأ في تحميل التعليقات",
  "forumCommentsEmptyTitle": "لا توجد تعليقات بعد",
  "forumCommentsEmptySubtitle": "كن أول من يرد على هذا الموضوع.",
  "forumRepliesCount": "{count,plural, =1{رد واحد} other{{count} ردود}}",
  "forumRoleInstructor": "مدرب",
  "forumErrorFailedToPostReply": "فشل في نشر الرد"
}''';

  final keysMl = '''
  "forumErrorFailedToCreatePost": "പോസ്റ്റ് നിർമ്മിക്കുന്നതിൽ പരാജയപ്പെട്ടു",
  "forumErrorDiscussionNotFound": "ചർച്ച കണ്ടെത്തിയില്ല",
  "forumErrorLoadingComments": "അഭിപ്രായങ്ങൾ ലോഡുചെയ്യുന്നതിൽ പിശക്",
  "forumCommentsEmptyTitle": "അഭിപ്രായങ്ങളൊന്നുമില്ല",
  "forumCommentsEmptySubtitle": "ഈ ത്രെഡിന് ആദ്യം മറുപടി നൽകൂ.",
  "forumRepliesCount": "{count,plural, =1{1 മറുപടി} other{{count} മറുപടികൾ}}",
  "forumRoleInstructor": "ഇൻസ്ട്രക്ടർ",
  "forumErrorFailedToPostReply": "മറുപടി പോസ്റ്റ് ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു"
}''';

  await appendToArb('packages/core/lib/l10n/app_en.arb', keysEn);
  await appendToArb('packages/core/lib/l10n/app_ar.arb', keysAr);
  await appendToArb('packages/core/lib/l10n/app_ml.arb', keysMl);
}

Future<void> appendToArb(String path, String appendedKeys) async {
  final file = File(path);
  String content = await file.readAsString();
  int lastBraceIndex = content.lastIndexOf('}');
  if (lastBraceIndex != -1) {
    String newContent = content.substring(0, lastBraceIndex) + ',\\n' + appendedKeys;
    await file.writeAsString(newContent);
    print('Updated \$path');
  }
}
