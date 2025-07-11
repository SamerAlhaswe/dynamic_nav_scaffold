import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DynamicNavScaffold extends StatefulWidget
{
  /* Example [navDestinations] List
    [
      {'label':'WishList','icon':context.platformIcons.favoriteOutline,'active_icon':context.platformIcons.favoriteSolid,'body':Center(child: Text("Hello, Favorite"))},
      {'label':'Account','icon':context.platformIcons.personOutline,'active_icon':context.platformIcons.person, 'body': Center(child: Text('Hello, Person'))},
      {'label':'Cart','icon':context.platformIcons.shoppingCartOutline,'active_icon':context.platformIcons.shoppingCart, 'body': Center(child: Text('Hello, Cart'))}
    ]
  */
  final List<Map> navDestinations;
  final Color? backgroundColor;
  final AppBar appBar;
  final ValueChanged? onIndexChanged;
  Widget? floatingActionButton;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;
  List<Widget>? persistentFooterButtons;
  AlignmentDirectional persistentFooterAlignment;
  void Function(bool)? onEndDrawerChanged;
  Widget? bottomSheet;
  bool? resizeToAvoidBottomInset;
  bool primary;
  DragStartBehavior drawerDragStartBehavior;
  bool extendBody;
  bool extendBodyBehindAppBar;
  Color? drawerScrimColor;
  double? drawerEdgeDragWidth;
  bool drawerEnableOpenDragGesture;
  bool endDrawerEnableOpenDragGesture;
  String? restorationId;
  DynamicNavScaffold({
    super.key, 
    required this.navDestinations,
    required this.appBar,
    required this.onIndexChanged,
    final this.backgroundColor,
    final this.floatingActionButton,
    final this.floatingActionButtonLocation,
    final this.floatingActionButtonAnimator,
    final this.persistentFooterButtons,
    final this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    final this.onEndDrawerChanged,
    final this.bottomSheet,
    final this.resizeToAvoidBottomInset,
    final this.primary = true,
    final this.drawerDragStartBehavior = DragStartBehavior.start,
    final this.extendBody = false,
    final this.extendBodyBehindAppBar = false,
    final this.drawerScrimColor,
    final this.drawerEdgeDragWidth,
    final this.drawerEnableOpenDragGesture = true,
    final this.endDrawerEnableOpenDragGesture = true,
    final this.restorationId
  });
  @override
  State<DynamicNavScaffold> createState() => _DynamicNavScaffoldState();
}

class _DynamicNavScaffoldState extends State<DynamicNavScaffold> {
  int currentIndex = 0;
  
  bool get isMobile => Platform.isAndroid || Platform.isIOS;
  @override
  Widget build(BuildContext context) {
    bool isScreenLarge = MediaQuery.sizeOf(context).height > 400 && MediaQuery.sizeOf(context).width > 450 && MediaQuery.sizeOf(context).height / MediaQuery.sizeOf(context).aspectRatio > 1.2;
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation:widget.floatingActionButtonLocation,
      floatingActionButtonAnimator:widget.floatingActionButtonAnimator, 
      persistentFooterButtons:widget.persistentFooterButtons,
      persistentFooterAlignment:widget.persistentFooterAlignment,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      bottomSheet: widget.bottomSheet, 
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary:widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      restorationId: widget.restorationId,
      body: Row(children: [
        Visibility(
          visible: isScreenLarge,
          child: NavigationRail(
          labelType: NavigationRailLabelType.none,
          destinations: List.generate(widget.navDestinations.length, (index){
            return NavigationRailDestination(
              icon: Icon(widget.navDestinations[index]['icon']),
              selectedIcon: Icon(widget.navDestinations[index]['active_icon']),
              label: Text(widget.navDestinations[index]['label'])
            );
          }),
          selectedIndex: currentIndex,
          onDestinationSelected: (index){setState((){
            currentIndex = index;
            widget.onIndexChanged!(index);
          });},
        )
        ),
        Visibility(visible: isScreenLarge,child: VerticalDivider(thickness: 1)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isScreenLarge 
              ?  MediaQuery.sizeOf(context).width - 96
              : MediaQuery.sizeOf(context).width
            
          ),
          child: widget.navDestinations[currentIndex]['body'])
      ],),
      bottomNavigationBar: !isScreenLarge && isMobile
      ? NavigationBar(
        destinations: List.generate(widget.navDestinations.length, (index){
          return NavigationDestination(
            icon: Icon(widget.navDestinations[index]['icon']),
            selectedIcon: Icon(widget.navDestinations[index]['active_icon']),
            label: shortenString(widget.navDestinations[index]['label']),
            tooltip: widget.navDestinations[index]['label']
          );
        }),
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {setState((){
          currentIndex = index;
          widget.onIndexChanged!(index);
        });},
      ) 
      : null,
      backgroundColor: widget.backgroundColor,
      appBar: widget.appBar,
      drawer:
          isScreenLarge && !isMobile
          ? Drawer(
            child: Column(
              children: List.generate(widget.navDestinations.length + 1, (i){
                if(i == 0) {
                  return SizedBox(height: 84,);
                } else {
                  int index= i-1;
                  return ListTile(
                  trailing: Icon(widget.navDestinations[index]['icon']),
                  title: Text(widget.navDestinations[index]['label']),
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      widget.onIndexChanged!(index);
					  Navigator.pop(context);
                    });
                  } ,
                );
                }
              }),
            ),
          )
          : null,
      );
  }
}
// Set every element to be the first letter only except for first word (e.g  Home Page => Home P.)
String shortenString(String s) {
  // Split string into array of words
  int sLength = s.length;
  List<String> wordsList = [];
  String tmp = "";
  for(int i = 0; i < sLength; i++){
    String currentChar = s[i];
    // Check if the current char isn't a space or ampersand char or the last char
    // If it is one of these add the constructed word to the list and delete the constructed word from tmp
    if(currentChar == ' '|| i == sLength - 1 || currentChar == '&')
    {
      tmp += currentChar;
      wordsList.add(tmp);
      tmp = "";
    }
    // If it isn't construct the word char-by-char in the tmp string 
    else
    {
      tmp += currentChar;
    }
  }
  // If the words list has more than word
  if(wordsList.length > 1)
  {
    for(int i = 0; i < wordsList.length; i++)
    {
      String word = wordsList[i];
      // if it's the first word then just show it without alteration; NOTE: tmp here is just being reused , it's empty
      if(i == 0)
      {
        tmp += word;
      }
      // Else if it's not the first word the just show the first letter with a dot indicating the shortening
      else {
        // check if the word starts with the definite article in arabic then skip the first 2 chars and use the 3rd one
        if("${word[0]}${word[1]}" == "ال"){
          tmp += '${word[2]}';
        }
        // else use the first char
        else tmp += '${word[0]}.';
      }
    }
  }
  // If the wordlist has just one word assing tmp to directly be that word
  else {
    tmp = wordsList[0];
  }
  return tmp;
}
