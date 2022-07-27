import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/languageCubit.dart';
import 'package:carwash/screens/Auth/signin/ui/signin_ui.dart';
import 'package:carwash/screens/Drawer/drawer.dart';
import 'package:carwash/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../Auth/login.dart';
import '../../Home/home.dart';

class SelectLanguage extends StatefulWidget {
  final bool isStart;

  SelectLanguage([this.isStart = false]);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  late LanguageCubit _languageCubit;
  int? _selectedLanguage = -1;
  @override
  void initState() {
    super.initState();
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
  }

  // bool selected = false;
  int? group;
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var locale = AppLocalizations.of(context)!;
    List languages = [
      locale.eng,
      locale.arab,
      locale.frnch,
      locale.prtguese,
      locale.indonesia,
      locale.spansh,
      locale.italy,
      locale.swahilii,
      locale.turk
    ];

    return FadedSlideAnimation(
      Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              locale.selectLanguage!,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            leading: widget.isStart
                ? SizedBox.shrink()
                : IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: iconFgColor,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    })),
        drawer: MyDrawer(),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      color: Theme.of(context).backgroundColor,
                      child: RadioListTile(
                        activeColor: Color(0xff29ee86),
                        // tileColor: Theme.of(context).backgroundColor,
                        title: Text(languages[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 17)),
                        value: index,
                        groupValue: _selectedLanguage,
                        onChanged: (dynamic val) {
                          setState(() {
                            _selectedLanguage = val;
                            print(val);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                    onTap: () {
                      if (_selectedLanguage == 0) {
                        _languageCubit.selectEngLanguage();
                      } else if (_selectedLanguage == 1) {
                        _languageCubit.selectArabicLanguage();
                      } else if (_selectedLanguage == 2) {
                        _languageCubit.selectFrenchLanguage();
                      } else if (_selectedLanguage == 3) {
                        _languageCubit.selectPortugueseLanguage();
                      } else if (_selectedLanguage == 4) {
                        _languageCubit.selectIndonesianLanguage();
                      } else if (_selectedLanguage == 5) {
                        _languageCubit.selectSpanishLanguage();
                      } else if (_selectedLanguage == 6) {
                        _languageCubit.selectItalianLanguage();
                      } else if (_selectedLanguage == 7) {
                        _languageCubit.selectSwahiliLanguage();
                      } else if (_selectedLanguage == 8) {
                        _languageCubit.selectTurkishLanguage();
                      }
                      if (widget.isStart) {
                        if (FirebaseAuth.instance.currentUser != null) {
                          Get.offAll(HomeScreen());
                        }else{
                          Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: GradientButton(locale.save)),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
