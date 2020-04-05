package com.tbm.studentsocialgooglecalendar;

import android.util.Log;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import java.io.InputStream;
import java.util.Iterator;


public class XLSReader {

    public static String readExcelFile(InputStream input) {
        String result = "";

        try {
            //  open excel sheet
            // Create a POI File System object
            POIFSFileSystem myFileSystem = new POIFSFileSystem(input);
            // Create a workbook using the File System
            HSSFWorkbook myWorkBook = new HSSFWorkbook(myFileSystem);
            // Get the first sheet from workbook
            HSSFSheet mySheet = myWorkBook.getSheetAt(0);
            // We now need something to iterate through the cells.
            Iterator<Row> rowIter = mySheet.rowIterator();
            Log.e("START READ EXCEL:", "Reading");
            while (rowIter.hasNext()) {
                HSSFRow myRow = (HSSFRow) rowIter.next();
                Iterator<Cell> cellIter = myRow.cellIterator();
                String line = "";
                while (cellIter.hasNext()) {
                    HSSFCell myCell = (HSSFCell) cellIter.next();
                    line += myCell.toString() + "|";
                }
                if (!line.contains("->")) {
                    continue;
                }
                line = line.replace("||||", "|");
                line = line.replace("|||", "|");
                line = line.replace("||", "|");
                line = line.replace("||", "|");
                if (line.endsWith("|")) {
                    line = line.substring(0, line.length() - 1);
                }
//                Log.d("line:", line.split("[|]").length + " => " + line.split("[|]")[0]);
                result += line + "\n";
            }
            return result;
        } catch (Exception e) {
            Log.e("XLSReader", "error " + e.toString());
            return "";
        }
    }
}
