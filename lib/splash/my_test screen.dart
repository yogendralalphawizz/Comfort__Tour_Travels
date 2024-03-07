import 'package:flutter/material.dart';



class SleeperBus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleeper Bus'),
      ),
      body: BusLayout(),
    );
  }
}

class BusLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            child: Column(
      
              children: [
                Text('Uper'), 
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
      
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(width: 20,height: 40,color: Colors.grey,),
                        ),
                        Expanded(
                           flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Container(width: 20,height: 40,color: Colors.grey,),
                            SizedBox(width: 2,),
                            Container(width: 20,height: 40,color: Colors.grey,),
                          ],),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(

              children: [
                Text('Lower'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(width: 20,height: 40,color: Colors.grey,),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                            Container(width: 20,height: 40,color: Colors.grey,),
                            SizedBox(width: 2,),
                            Container(width: 20,height: 40,color: Colors.grey,),
                          ],),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeckLayout extends StatelessWidget {
  final String deckType;
  final String side;

  DeckLayout({required this.deckType, required this.side});

  @override
  Widget build(BuildContext context) {
    List<int> berthIds = [];

    // Define berth IDs based on deck type and side
    if (deckType == 'Upper' && side == 'Left') {
      berthIds = [1, 3, 5, 7, 9];
    } else if (deckType == 'Upper' && side == 'Right') {
      berthIds = [2, 4, 6, 8, 10];
    } else if (deckType == 'Lower' && side == 'Left') {
      berthIds = [11, 13, 15, 17, 19, 21, 23, 25, 27, 29];
    } else if (deckType == 'Lower' && side == 'Right') {
      berthIds = [12, 14, 16, 18, 20, 22, 24, 26, 28, 30];
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: berthIds.length,
      itemBuilder: (BuildContext context, int index) {
        int berthId = berthIds[index];
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            border: Border.all(),
          ),
          child: Text('Berth $berthId'),
        );
      },
    );
  }
}