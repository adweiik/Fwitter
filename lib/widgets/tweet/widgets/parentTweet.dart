import 'package:flutter/material.dart';
import 'package:twitter/helper/enum.dart';
import 'package:twitter/model/feedModel.dart';
import 'package:twitter/state/feedState.dart';
import 'package:twitter/ui/page/feed/feedPostDetail.dart';
import 'package:twitter/widgets/tweet/tweet.dart';
import 'package:twitter/widgets/tweet/widgets/unavailableTweet.dart';
import 'package:provider/provider.dart';

class ParentTweetWidget extends StatelessWidget {
  const ParentTweetWidget(
      {Key? key,
      required this.childRetwetkey,
      required this.type,
      this.trailing})
      : super(key: key);

  final String childRetwetkey;
  final TweetType type;
  final Widget? trailing;

  void onTweetPressed(BuildContext context, FeedModel model) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    feedstate.getPostDetailFromDatabase(null, model: model);
    Navigator.push(context, FeedPostDetail.getRoute(model.key!));
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    return FutureBuilder(
      future: feedstate.fetchTweet(childRetwetkey),
      builder: (context, AsyncSnapshot<FeedModel?> snapshot) {
        if (snapshot.hasData) {
          return Tweet(
            model: snapshot.data!,
            type: TweetType.ParentTweet,
            trailing: trailing,
            scaffoldKey: GlobalKey<ScaffoldState>(),
          );
        }
        if ((snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.waiting) &&
            !snapshot.hasData) {
          return UnavailableTweet(
            snapshot: snapshot,
            type: type,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
