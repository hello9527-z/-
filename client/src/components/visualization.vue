<template>
  <div class="vis">
    <div style="line-height: 40px">
      <i class="el-icon-back" @click="goBack"></i>
      <span @click="goBack">返回</span>
      <el-button type="primary" style="float: right" @click="Again"
        >Again</el-button
      >
    </div>
    <div v-if="isshow == 'table'">
      <el-table :data="resultsArr" style="width: 100%">
        <el-table-column
          v-for="i in lengthArr"
          :key="i.index"
          :prop="i"
          width="150"
        >
        </el-table-column>
      </el-table>
    </div>
    <div v-show="isLineBar">
      <div
        class="text item"
        id="my_charts_line_bar"
        style="height: 400px; width: 700px"
      ></div>
    </div>
    <div v-show="isPie">
      <div
        class="text item"
        id="my_charts_pie"
        style="height: 400px; width: 700px"
      ></div>
    </div>
    <div v-show="isscatter">
      <div
        class="text item"
        id="my_charts_scatter"
        style="height: 400px; width: 700px"
      ></div>
    </div>
  </div>
</template>

<script>
import * as echarts from "echarts";
export default {
  name: "visualization",
  props: {
    resultsArr: Array,
    chartType: String,
    lineBarX: String,
    lineBarY: String,
    filename: String,
    deleteData: String,
  },
  data() {
    return {
      lineBarXArr: [],
      lineBarYArr: [],
      lengthArr: [],
      ScatterArr: [],
      isshow: "",
      isLineBar: false,
      isPie: false,
      isscatter: false,
    };
  },
  mounted() {
    this.delete();
    this.result();
  },
  methods: {
    delete() {
      if (this.deleteData != "") {
        let deleteDataArr=this.deleteData.split(",")
        for (let index = 0; index < deleteDataArr.length; index++) {
          this.resultsArr.splice(deleteDataArr[index], 1);
        }
      }
    },
    result() {
      if (this.chartType === "表格") {
        for (let i = 0; i < this.resultsArr[1].length; i++) {
          this.lengthArr.push(`${i}`);
        }
        this.isshow = "table";
      }
      if (this.chartType === "折线图" || this.chartType === "柱状图") {
        this.resultsArr.forEach((ele) => {
          if (ele != "") {
            this.lineBarXArr.push(ele[parseInt(this.lineBarX)]);
            this.lineBarYArr.push(ele[parseInt(this.lineBarY)]);
          }
        });
        this.isLineBar = true;
        this.echartBar(
          this.lineBarXArr,
          this.lineBarYArr,
          "my_charts_line_bar",
          this.filename
        );
      }
      if (this.chartType === "饼状图") {
        this.isPie = true;
        setTimeout(() => {
          this.echartPie("my_charts_pie", this.filename, this.resultsArr);
        }, 1000);
      }
      if (this.chartType == "散点图") {
        this.isscatter = true;
        this.resultsArr.forEach((ele) => {
          if (ele != "") {
            let SX = ele[parseInt(this.lineBarX)];
            let SY = ele[parseInt(this.lineBarY)];
            this.ScatterArr.push([SX, SY]);
          }
        });
        this.echartScatter(this.ScatterArr, "my_charts_scatter", this.filename);
      }
    },
    echartBar(lineBarXArr, lineBarYArr, domID, name) {
      let myChartLine = echarts.init(document.getElementById(domID));
      myChartLine.setOption({
        title: {},
        tooltip: {
          trigger: "axis",
        },
        legend: {},
        toolbox: {
          show: true,
          feature: {
            dataView: { readOnly: false },
            magicType: { type: ["line", "bar"] },
            saveAsImage: {
              name: name,
            },
            right: "5%",
          },
        },
        xAxis: {
          type: "category",
          boundaryGap: false,
          data: lineBarXArr,
        },
        yAxis: {
          type: "value",
          name: "Frequency",
          nameLocation: "center",
          nameTextStyle: {
            fontSize: 16,
            fontWeight: "bold",
            padding: 30,
          },
          axisLine: {
            show: true,
          },
        },
        series: [
          {
            type: "line",
            data: lineBarYArr,
            showBackground: true,
            backgroundStyle: {
              color: "rgba(180, 180, 180, 0.2)",
            },
            markPoint: {
              data: [
                { type: "max", name: "Max" },
                { type: "min", name: "Min" },
              ],
            },
            markLine: {
              data: [{ type: "average", name: "Avg" }],
            },
          },
        ],
      });
      window.addEventListener("resize", function () {
        myChartLine.resize();
      });
    },
    echartPie(domID, name, PieData) {
      let myChartPie = echarts.init(document.getElementById(domID));
      myChartPie.setOption({
        tooltip: {
          trigger: "item",
        },
        toolbox: {
          feature: {
            saveAsImage: {
              name: name,
            },
            dataView: {
              readOnly: false,
            },
          },
          right: "5%",
        },
        legend: {
          orient: "vertical",
          left: "left",
        },
        series: [
          {
            type: "pie",
            radius: "50%",
            data: [
              { name: "Mono", value: 0 },
              { name: "Di", value: 0 },
              { name: "Tri", value: 0 },
              { name: "Tetra", value: 0 },
              { name: "Penta", value: 0 },
              {
                name: "Hexa",
                value: 0,
              },
            ],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      });
      window.addEventListener("resize", function () {
        myChartPie.resize();
      });
    },
    echartScatter(Data, domID, name) {
      let chartDom = document.getElementById(domID);
      let myChartScatter = echarts.init(chartDom);
      myChartScatter.setOption({
        tooltip: {
          trigger: "item",
        },
        toolbox: {
          feature: {
            saveAsImage: {
              name: name,
            },
            dataView: {
              readOnly: false,
            },
          },
          right: "5%",
        },
        legend: {
          orient: "vertical",
          left: "left",
        },
        xAxis: {},
        yAxis: {},
        series: [
          {
            type: "scatter",
            data: Data,
            xAxisIndex: 0,
            yAxisIndex: 0,
          },
        ],
      });
      window.addEventListener("resize", function () {
        myChartScatter.resize();
      });
    },
    goBack() {
      this.$emit("pre");
    },
    Again() {
      this.$emit("Again");
    },
  },
};
</script>

<style>
.vis {
  width: 100%;
  height: 100%;
}
</style>
