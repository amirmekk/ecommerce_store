import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/widgets/product_item.dart';
import 'package:google_fonts/google_fonts.dart';

class Products extends StatefulWidget {
  final void Function() onInit;
  Products({this.onInit});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      leading:
          IconButton(icon: Icon(Icons.menu), onPressed: () {}, iconSize: 30),
      actions: <Widget>[
        IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.perm_identity,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            }),
      ],
    );
  }

  Widget customBottomNavBar(BuildContext context, AppState store) {
    return SizedBox(
      height: 120.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              '____________',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Center(
              child: store.user == null
                  ? Text(
                      'Welcome',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                  : Text(
                      'Weclome ${store.user.username}!',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
            ),
            BottomNavigationBar(
              elevation: 0,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  title: Text(''),
                  icon: Icon(
                    Icons.home,
                  ),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.bookmark),
                  title: Text(''),
                  icon: Icon(
                    Icons.bookmark_border,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon: Icon(
                    Icons.shopping_basket,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productList(BuildContext context, AppState store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'For You',
            style: GoogleFonts.getFont(
              'Manrope',
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: store.products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProuctItem(store.products[index]);
            },
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //List<Widget> _children = [Text('1'), Text('2'), Text('3')];
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          body: productList(context, state),
          bottomNavigationBar: customBottomNavBar(context, state),
          appBar: customAppBar(context),
        );
      },
    );
  }
}
