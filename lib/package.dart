import 'package:flutter/material.dart';
import 'package:sample_from_timelines/utils/dimentions.dart';
import 'package:timelines/timelines.dart';
import '../widget.dart';

const kTileHeight = 50.0;

class PackageDeliveryTrackingPage extends StatelessWidget {

  late double width;
  late double paddingHorizontal;
  late double paddingVertical;

  // PackageDeliveryTrackingPage({super.key});

  PackageDeliveryTrackingPage(
      {
        required this.width,
        required this.paddingHorizontal,
        required this.paddingVertical,
        });


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TitleAppBar('Package Delivery Tracking'),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final data = _data(index + 1);
          return Center(
            child: Container(
              width: AppDimension.width(figmaWidth: width, context: context), //460
              child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DeliveryProcesses(width: width,
                        paddingHorizontal: paddingHorizontal,
                        paddingVertical: paddingVertical,
                        processes: data.deliveryProcesses),
                  ],
                ),

            ),
          );
        },itemCount: 1,
      ),
    );
  }
}



class _InnerTimeline extends StatelessWidget {

  final List<_DeliveryMessage> messages;
  late double width;
  late double paddingHorizontal;
  late double paddingVertical;

  _InnerTimeline({
    required this.messages,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.width,

  });


  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
            thickness: 1, // inner line thickness = 1
          ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
            size: 10.0,
            position: 0.5,

          ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
          !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => isEdgeIndex(index) || isEdgeIndex(index-1) ?null:Connector.solidLine(),
          endConnectorBuilder: (_, index) => index==0|| index==messages.length|| index==messages.length+1?null:Connector.solidLine(),

          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
          isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {


  late double width;
  late double paddingHorizontal;
  late double paddingVertical;

  _DeliveryProcesses({Key? key,required this.width,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.processes})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0.4,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData( // big node
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,


            // left side text
            oppositeContentsBuilder: (_, index) {
              // if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].leftname,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18.0,
                      ),
                    ),
                    Opacity(opacity: 0.0, child: new Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: _InnerTimeline(
                          messages: processes[index].messages,
                        width: width,
                        paddingVertical: paddingVertical,
                        paddingHorizontal: paddingHorizontal,
                      ),
                    ))


                  ],
                ),
              );
            },


            // right side text
            contentsBuilder: (_, index) {
              // if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18.0,
                      ),
                    ),
                    _InnerTimeline(messages: processes[index].messages,width: width,
                      paddingVertical: paddingVertical,
                      paddingHorizontal: paddingHorizontal,),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  size: 24,
                  child: Icon(
                    Icons.check, // different color icon
                    color: Colors.white,
                    size: 18.0,
                  ),
                );
              } else {
                return DotIndicator(
                  size: 24,
                  child: Icon(
                    Icons.delivery_dining, // normal icon
                    color: Colors.white,
                    size: 18.0,
                  ),
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}



_OrderInfo _data(int id) => _OrderInfo(
  id: id,
  deliveryProcesses: [
    _DeliveryProcess(
      'Package Process', // right text
        "15 Aug 2022\n4:00 am", // left text
      messages: [
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades'),

      ],

    ),
    _DeliveryProcess(
      'Package Process is going to be delivered ', // right text
      "15 Aug 2022\n4:00 am", // left text
      messages: [
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades Package delivered by m.vassiliadesPackage'),

      ],

    ),
    _DeliveryProcess(
      '',
        "15 Aug 2022\n4:00 am",
      messages: [
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades. Package delivered by m.vassiliades'),
        _DeliveryMessage('Package delivered by m.vassiliades'),
      ],
    ),

    _DeliveryProcess.complete(
        "4:00 am\n 2022",
    ),

  ],
);

class _OrderInfo {
  const _OrderInfo({
    required this.id,
    required this.deliveryProcesses,
  });

  final int id;
  final List<_DeliveryProcess> deliveryProcesses;
}


class _DeliveryProcess {
  const _DeliveryProcess(
      this.name, this.leftname, {
        this.messages = const [],
      });

  const _DeliveryProcess.complete(this.leftname)
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final String leftname;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage( this.message);


  final String message;

  @override
  String toString() {
    // return '$createdAt $message';
    return '$message';
  }
}