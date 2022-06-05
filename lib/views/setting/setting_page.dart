import 'package:dmapicore/bloc/setting/app_config_cubit.dart';
import 'package:dmapicore/model/common/load_status_model.dart';
import 'package:dmapicore/views/setting/download_page.dart';
import 'package:dmapicore/views/setting/local_comic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AppConfigCubit, AppConfigState>(
      listener: (context, state) {},
      builder: (context, state) {
        final index = Colors.primaries.indexWhere(
            (element) => element.value == state.appConfig.colorSeed);
        final ScrollController scrollController =
            ScrollController(initialScrollOffset: index > 0 ? index * 96 : 0);
        if (state.status.isInitial) {
          context.read<AppConfigCubit>().fetchData();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("设置"),
            centerTitle: true,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ListTile(
                title: const Text("主题模式"),
                subtitle: Text(state.appConfig.themeMode.getTitle()),
                trailing: TextButton(
                  child: Icon(state.appConfig.themeMode.getIcon()),
                  onPressed: () {
                    context.read<AppConfigCubit>().toggleThemeMode();
                  },
                ),
              ),
              ListTile(
                title: const Text("主题颜色"),
                trailing: TextButton(
                  child: state.appConfig.isSysColor
                      ? Icon(
                          Icons.hdr_auto,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.color_lens_outlined,
                          color: Color(state.appConfig.colorSeed),
                        ),
                  onPressed: () {
                    context.read<AppConfigCubit>().toggleThemeColorMode();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                margin: const EdgeInsets.all(4),
                child: state.appConfig.isSysColor
                    ? Center(
                        child: ThemePresent(
                          lightScheme: state.appLightScheme!,
                          darkScheme: state.appDarkScheme!,
                          brightness: theme.brightness,
                          selected: true,
                          onTap: () {},
                        ),
                      )
                    : ListView.builder(
                        cacheExtent: MediaQuery.of(context).size.width,
                        controller: scrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final color = Colors.primaries.elementAt(index);
                          return ThemePresent(
                            lightScheme: ColorScheme.fromSeed(
                              seedColor: color,
                            ),
                            darkScheme: ColorScheme.fromSeed(
                                seedColor: color, brightness: Brightness.dark),
                            brightness: theme.brightness,
                            selected: color.value == state.appConfig.colorSeed,
                            onTap: () {
                              context
                                  .read<AppConfigCubit>()
                                  .changeColorSeed(color.value);
                            },
                          );
                        },
                        itemCount: Colors.primaries.length,
                      ),
              ),
              ListTile(
                title: const Text("显示模式"),
                trailing: DropdownButton<DisplayMode>(
                  value: state.appConfig.displayMode,
                  items: state.displayModeList
                      .map((e) => DropdownMenuItem<DisplayMode>(
                            value: e,
                            child: Text(e.refreshRate.toString()),
                          ))
                      .toList(),
                  onChanged: (DisplayMode? value) {},
                ),
              ),
              ListTile(
                title: const Text("下载列队"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DownloadPage(),
                    ),
                  );
                },
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Color(state.appConfig.colorSeed),
                ),
              ),
              ListTile(
                title: const Text("本地漫画"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LocalComicPage(),
                    ),
                  );
                },
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Color(state.appConfig.colorSeed),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThemePresent extends StatelessWidget {
  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final Brightness brightness;
  final bool selected;
  final VoidCallback onTap;

  const ThemePresent({
    Key? key,
    required this.lightScheme,
    required this.darkScheme,
    required this.selected,
    required this.onTap,
    required this.brightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.light
        ? ThemeData.light().copyWith(
            useMaterial3: true,
            colorScheme: lightScheme,
          )
        : ThemeData.dark().copyWith(
            useMaterial3: true,
            colorScheme: darkScheme,
          );
    return Material(
      child: Ink(
        padding: const EdgeInsets.all(4),
        child: Ink(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? theme.colorScheme.primary : theme.highlightColor,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            splashColor: theme.colorScheme.surfaceVariant,
            onTap: () => onTap(),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: theme.colorScheme.background,
              ),
              width: 80,
              height: 128,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 16,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(8),
                            ),
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 16,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8),
                            ),
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 32,
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 24,
                      width: 24,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.tertiaryContainer,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Ink(
                    height: 28,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      color: theme.colorScheme.surfaceVariant,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
