import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/UserProfile/FinancialAnaly/financialModels.dart';
import 'package:untitled1/config/constants.dart';
import 'package:untitled1/UserProfile/FinancialAnaly/spendingAmountWithCategory.dart';
import 'package:untitled1/UserProfile/FinancialAnaly/spendingTrends.dart';
import 'package:untitled1/UserProfile/FinancialAnaly/spendingDetails.dart';

class FinancialAnaly extends StatefulWidget {
  final int userNo;

  FinancialAnaly({required this.userNo});

  @override
  _FinancialAnalyState createState() => _FinancialAnalyState();
}

class _FinancialAnalyState extends State<FinancialAnaly> {
  String userName = '사용자'; // 기본값 설정
  @override
  void initState() {
    super.initState();
    _loadUserName(); // 초기화 시 사용자 이름 불러오기
  }

  // 로컬에 저장된 사용자 이름 불러오기
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '사용자';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // 배경색 변경
      appBar: AppBar(
        title: const Text(
          "내 금융 상태",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800], // AppBar 색상 변경
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              FutureBuilder<List<CategorySpendingSummary>>(
                future: fetchTop5Categories(widget.userNo), // 예시로 userNo = 1
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  } else {
                    return Column(
                      children: [
                        _buildSpendingTypeSection(snapshot.data![0].category),
                        const SizedBox(height: 20),
                        FutureBuilder<Map<String, CategorySpendingAvgDTO>>(
                          future: fetchTop5CategoriesWithAvg(widget.userNo), // 예시로 userNo = 1
                          builder: (context, avgSnapshot) {
                            if (avgSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (avgSnapshot.hasError) {
                              return Text('Error: ${avgSnapshot.error}');
                            } else if (!avgSnapshot.hasData || avgSnapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return _buildHistogramChart(snapshot.data!, avgSnapshot.data!);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<FinancialTrendDTO>>(
                          future: fetchSpendingTrends(widget.userNo), // 예시로 userNo = 1
                          builder: (context, trendSnapshot) {
                            if (trendSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (trendSnapshot.hasError) {
                              return Text('Error: ${trendSnapshot.error}');
                            } else if (!trendSnapshot.hasData || trendSnapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return _buildAnalysisSummary(trendSnapshot.data!);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<CategorySpendingSummary>>(
                          future: fetchLast7DaysSpending(widget.userNo), // 예시로 userNo = 1
                          builder: (context, donutSnapshot) {
                            if (donutSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (donutSnapshot.hasError) {
                              return Text('Error: ${donutSnapshot.error}');
                            } else if (!donutSnapshot.hasData || donutSnapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return _buildDonutChart(donutSnapshot.data!);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<StoreSpendingSummary>>(
                          future: fetchHighestSpendingDetails(widget.userNo), // 예시로 userNo = 1
                          builder: (context, detailsSnapshot) {
                            if (detailsSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (detailsSnapshot.hasError) {
                              return Text('Error: ${detailsSnapshot.error}');
                            } else if (!detailsSnapshot.hasData || detailsSnapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return _buildCategorySpendingSummary(detailsSnapshot.data!);
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingTypeSection(String category) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$userName님의 지출타입은?\n"프로 $category러"',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildHistogramChart(
      List<CategorySpendingSummary> barData, Map<String, CategorySpendingAvgDTO> lineData) {
    final ageGroup = lineData.values.isNotEmpty ? lineData.values.first.ageGroup : '알 수 없음';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '이번달 지출 상위 5개 카테고리',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4),
          Center(
            child: Text(
              '나 vs (${ageGroup}) 평균 지출',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: _createHistogramBarGroups(barData, lineData),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          barData[value.toInt()].category,
                          style: TextStyle(fontSize: 8), // category 텍스트 크기 조정
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _createHistogramBarGroups(
      List<CategorySpendingSummary> barData, Map<String, CategorySpendingAvgDTO> lineData) {
    return List.generate(barData.length, (index) {
      final category = barData[index];
      final avgSpending = lineData[category.category]?.avgAmount ?? 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: category.totalAmount.toDouble(),
            color: const Color.fromARGB(255, 163, 214, 255),
            width: 15,
          ),
          BarChartRodData(
            toY: avgSpending.toDouble(),
            color: const Color.fromARGB(255, 255, 182, 193),
            width: 15,
          ),
        ],
        barsSpace: 10,
      );
    });
  }

  Widget _buildAnalysisSummary(List<FinancialTrendDTO> trends) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '$userName님의 지난달 대비 이번달 소비 트렌드',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          ..._buildTrendsSummary(trends),
        ],
      ),
    );
  }

  List<Widget> _buildTrendsSummary(List<FinancialTrendDTO> trends) {
    List<Widget> trendWidgets = [];
    for (var i = 0; i < trends.length; i += 3) {
      List<Widget> rowItems = [];
      for (var j = i; j < i + 3 && j < trends.length; j++) {
        final trend = trends[j];
        rowItems.add(
          Expanded(
            child: Text(
              trend.totalAmountBefore == 0
                  ? '정보 없음'
                  : '${trend.category}: ${trend.percentChange > 0 ? '+' : ''}${trend.percentChange.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 12, // 텍스트 크기 조정
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      trendWidgets.add(Row(children: rowItems));
    }

    return trendWidgets;
  }

  Widget _buildDonutChart(List<CategorySpendingSummary> data) {
    final List<Color> predefinedColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.lime,
      Colors.indigo,
      Colors.brown,
      Colors.deepPurple,
      Colors.blueGrey,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.yellow,
      Colors.grey,
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
    ];
    final random = Random();
    final sectionColors = List.generate(
      data.length,
          (_) => predefinedColors[random.nextInt(predefinedColors.length)],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '최근 일주일 소비 카테고리 분포',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: _createPieSections(data, sectionColors),
                centerSpaceRadius: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createPieSections(List<CategorySpendingSummary> data, List<Color> sectionColors) {
    return List.generate(data.length, (index) {
      final percentage = (data[index].totalAmount / data.map((e) => e.totalAmount).reduce((a, b) => a + b)) * 100;
      return PieChartSectionData(
        color: sectionColors[index],
        value: data[index].totalAmount.toDouble(),
        title: '${data[index].category} ${percentage.toStringAsFixed(1)}%',
        titleStyle: TextStyle(fontSize: 10), // 그래프 속 텍스트 크기 조정
      );
    });
  }

  Widget _buildCategorySpendingSummary(List<StoreSpendingSummary> details) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${detail.storeName} (${detail.visitCount}회 방문) - ${detail.totalAmount}원',
              style: const TextStyle(
                fontSize: 5, // 텍스트 크기 조정
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }
}
